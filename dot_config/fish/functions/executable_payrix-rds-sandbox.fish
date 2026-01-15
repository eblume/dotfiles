function payrix-rds-sandbox --description="Connect to sandbox psql rds"
    set -f aws_profile payrix-sandbox
    set -f jump_host_name sandbox-jobs-1
    set -f db_host "payrix-sandbox-api-cluster.cluster-cfv6yjj08qvp.us-east-1.rds.amazonaws.com"
    set -f remote_port 5432
    set -f local_port 5432
    set -f pg_user payrixroot
    set -f pg_db payrix
    set -f op_vault jpurcmohy6ayoy56xv2sf4jete
    set -f op_secret vd6tqrrwkhqswii3cfdzxzkgc4
    set -f op_field password
    set -f pg_pass (op --vault $op_vault item get $op_secret --reveal --fields $op_field)
    set -f psql_bin (brew --prefix postgresql@13)"/bin/psql"

    # Sometimes op will quote passwords with weird characters, TRY and strip that out, if not just use it raw
    set -f maybe_password (echo $pg_pass | jq -r 2>/dev/null)
    if test $status -eq 0
        set -f pg_pass $maybe_password
    end

    # Grab jump_host instance ID using its name tag
    set -f jump_host (aws-vault exec $aws_profile -- aws ec2 describe-instances --filters Name=tag:Name,Values="$jump_host_name" --query 'Reservations[0].Instances[0].InstanceId' --output text)
    if test -z "$jump_host"
        echo "Failed to find instanceiD of the jump host '$jump_host_name'"
        return 1
    end

    # We'll capture all stdout/stderr in this temp file so we can parse out the session ID
    set -f ssm_log_file (mktemp)
    echo "Logging SSM to $ssm_log_file"

    # Start the SSM session in the background, capturing its output
    aws-vault exec $aws_profile -- \
        aws ssm start-session \
        --target "$jump_host" \
        --document-name AWS-StartPortForwardingSessionToRemoteHost \
        --parameters "{\"host\":[\"$db_host\"], \"portNumber\":[\"$remote_port\"], \"localPortNumber\": [\"$local_port\"]}" >$ssm_log_file 2>&1 &

    set -f ssm_pid $last_pid

    #
    # We'll try to parse the SessionId out of the log file
    # Something like: "Starting session with SessionId: myuser-0123456789abcdef"
    #
    set -f session_id ""
    for i in (seq 1 60)
        # Wait a bit for the session to start printing
        sleep 1
        if test -e $ssm_log_file
            set -f session_id (grep -m1 -o 'SessionId: [^ ]*' $ssm_log_file | sed 's/SessionId: //')
            if test -n "$session_id"
                break
            end
        end
        # If the background session process ended abruptly, bail out
        if not kill -0 $ssm_pid 2>/dev/null
            echo "SSM session process ended unexpectedly. Exiting."
            cat $ssm_log_file
            rm -f $ssm_log_file
            kill $ssm_pid
            return 1
        end
    end

    if test -z "$session_id"
        echo "Failed to parse SessionId from aws ssm start-session. See log below:"
        cat $ssm_log_file
        rm -f $ssm_log_file
        return 1
    end

    function cleanup-ssm --on-signal SIGINT
        echo "Caught Ctrl-C, terminating SSM session..."
        if test -n "$session_id"
            # Attempt to gracefully terminate the SSM session
            aws-vault exec $aws_profile -- \
                aws ssm terminate-session --session-id $session_id
        else
            # If we never got a session ID, fallback to kill
            kill $ssm_pid
        end
        rm -f $ssm_log_file
        exit 2
    end

    echo "Waiting for port $local_port to become available..."

    # Poll up to 120 seconds for the local port to be listening
    for i in (seq 120)
        sleep 1
        nc -z localhost $local_port
        if test $status -eq 0
            echo "SSM tunnel established on port $local_port"
            break
        end

        # If the SSM session process died, bail
        if not kill -0 $ssm_pid 2>/dev/null
            echo "SSM session process ended unexpectedly. Exiting."
            cat $ssm_log_file
            rm -f $ssm_log_file
            return 1
        end
    end

    if test $i -ge 120
        echo "Timeout waiting for the SSM tunnel to establish (120s)."
        echo "Terminating SSM session $session_id..."
        aws-vault exec $aws_profile -- \
            aws ssm terminate-session --session-id $session_id
        rm -f $ssm_log_file
        return 1
    end

    # Create a pgpass file so we don't have to type the password
    set -f pgpass_file (mktemp)
    chmod u=rw,g=,o= $pgpass_file
    echo "127.0.0.1:$local_port:*:$pg_user:$pg_pass" >$pgpass_file

    # Connect via psql
    env PGPASSFILE=$pgpass_file \
        $psql_bin \
        --host=127.0.0.1 \
        --port=$local_port \
        --username=$pg_user \
        --dbname $pg_db

    # Cleanup at the end
    echo "Cleaning up pgpass_file and terminating SSM session"
    rm -f $pgpass_file

    # Terminate the SSM session instead of kill
    aws-vault exec $aws_profile -- \
        aws ssm terminate-session --session-id $session_id

    # Also clean up the captured log
    rm -f $ssm_log_file
end
