function payrix-amq --description="Connect to an amq broker. Uses FZF to select profile and broker."
    # Select AWS Profile
    set -l profile (aws-vault list --profiles | fzf --prompt="Choose AWS profile: ")
    if test -z "$profile"
        echo "No profile selected. Aborting."
        return 1
    end

    function aws-exec -S
        aws-vault exec $profile -- aws $argv
    end

    # Select AMQ Broker, find VPC and EC2 info
    echo "Loading broker data, can take a minute or two, please wait..."
    set -l brokers_json (aws-exec mq list-brokers)
    set -l broker_ids (echo $brokers_json | jq -r '.BrokerSummaries[].BrokerId')
    set -l broker_choices
    for broker_id in $broker_ids
        set -l desc (aws-exec mq describe-broker --broker-id $broker_id)
        set -l broker_name (echo $desc | jq -r '.BrokerName')
        set -l broker_id (echo $desc | jq -r '.BrokerId')
        set broker_choices $broker_choices "$broker_name [$broker_id]"
    end
    set -l selection (printf "%s\n" $broker_choices | fzf --prompt="Choose AMQ Broker: ")
    if test -z "$selection"
        echo "No broker selected. Aborting."
        return 1
    end
    set -l chosen_id (string match -rg '\[(.*)\]$' -- $selection)
    set -l description (aws-exec mq describe-broker --broker-id $chosen_id)
    set -l name (echo $description | jq -r '.BrokerName')
    set -l console_url (echo $description | jq -r '.BrokerInstances[].ConsoleURL')
    set -l amq_host (string replace -r '^(https?://)?([^/:]+)(:[0-9]+)?/?$' '$2' -- $console_url)
    set -l sg_id (echo $description | jq -r '.SecurityGroups[0]')
    if test -z "$sg_id"
        echo "No security group found for the broker."
        return 1
    end
    set -l sg_desc (aws-exec ec2 describe-security-groups --group-ids $sg_id)
    set -l vpc_id (echo $sg_desc | jq -r '.SecurityGroups[0].VpcId')
    if test -z "$vpc_id" -o "$vpc_id" = null
        echo "No VPC ID found for security group $sg_id"
        return 1
    end
    set -l ec2_instances_json (aws-exec ec2 describe-instances --filters "Name=vpc-id,Values=$vpc_id" "Name=instance-state-name,Values=running")
    set -l instance_infos (echo $ec2_instances_json | jq -c '.Reservations[].Instances[]')

    # From EC2 instances in broker's VPC, gather name info so we can pick the "best" one
    set -l instance_candidates
    for info in $instance_infos
        set -l instance_id (echo $info | jq -r '.InstanceId')
        set -l name (echo $info | jq -r '.Tags[]? | select(.Key == "Name") | .Value' | head -n 1)
        set -l marker ''
        if test -n "$name"
            if string match -qr 'job-dev$' -- $name
                set marker job-dev
            else if string match -qr 'job-[0-9]+$' -- $name
                set marker job-num
            else
                set marker other
            end
        else
            set marker none
        end
        # Push "marker,instance_id" into array for later sorting
        set instance_candidates $instance_candidates "$marker|$instance_id"
    end

    # Pick the "best" ec2 instance
    # Priority = job-dev > job-num > other/none
    set -l marker_order job-dev job-num other none
    set -l chosen_instance ''
    for category in $marker_order
        for candidate in $instance_candidates
            set -l marker (string split "|" -- $candidate)[1]
            if test "$marker" = "$category"
                set -l instance_id (string split "|" -- $candidate)[2]
                set chosen_instance "$instance_id"
                break
            end
        end
        if test -n "$chosen_instance"
            break
        end
    end

    if test -n "$chosen_instance"
        echo "Chosen EC2 instance ID in VPC $vpc_id: $chosen_instance"
    else
        echo "No EC2 instances found in VPC $vpc_id."
        return 1
    end

    # Open the browser in 5 seconds in the background
    echo "In 5 seconds, the browser will open to the AMQ queue found at $console_url, forwarded to localhost."
    fish -c 'sleep 5; open https://localhost:8162' &

    # Start SSM in foreground
    set -l parameters "{\"host\":[\"$amq_host\"], \"portNumber\":[\"8162\"], \"localPortNumber\": [\"8162\"]}"
    aws-exec ssm start-session \
        --target "$chosen_instance" \
        --document-name AWS-StartPortForwardingSessionToRemoteHost \
        --parameters "$parameters"
end
