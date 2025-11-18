function payrix-deploy-api --description="Deploy Core API with ansible"
    set -f env $argv[1] # sandbox, prodpci
    set -f ticket $argv[2] # CMP-3615
    set -f deploy_tag $argv[3] # api_v24.9.0_rc5
    ##
    if test (count $argv) -ne 3
        echo "Usage: $(status current-command) <env> <ticket> <deploy_tag>"
        echo "  env        one of: sandbox, prodpci"
        echo "  ticket     e.g. CMP-3615"
        echo "  deploy_tag must start with 'api_'"
        return 1
    end
    if not string match -q -r '^api_' $deploy_tag
        echo "ERROR: deploy_tag must start with 'api_'. Got: $deploy_tag" >&2
        return 1
    end
    set -f aws_profile "payrix-$env"
    z ansible
    if not git diff-index --quiet HEAD --
        echo "ERROR: working tree is not clean" >&2
        return 1
    end
    git switch main
    git pull --ff-only
    set -f prev_version (yq .api_git_tag $env/group_vars/all.yml)
    if not string match -q -r '^api_' $prev_version
        echo "ERROR: existing api_git_tag should start with 'api_'. Got: $prev_version" >&2
        return 1
    end
    if test $deploy_tag = $prev_version
        echo "WARNING: deploy_tag is the same as existing api_git_tag ($deploy_tag). Nothing to do." >&2
        return 1
    end
    git switch -c "feature/$ticket-$env-$deploy_tag"
    yq eval -i ".api_git_tag = \"$deploy_tag\"" $env/group_vars/all.yml
    git status
    set -f dd_url "https://app.datadoghq.com/apm/entity/service%3Acore-api-web?env=$env&fromUser=false&graphType=flamegraph&groupMapByOperation=null&shouldShowLegend=true&sort=time&spanKind=internal&paused=false"
    set -f fork_env ''
    if test (uname) = Darwin
        set -f fork_env "OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES " # Note extra space at end!
    end
    # To be further automated, but for now, just echo:
    echo
    echo
    echo "NEXT STEPS:"
    echo
    echo "git commit -am \"$ticket [$env] update api_git_tag to $deploy_tag\" && git push"
    echo "open \"$dd_url\""
    if test $env != sandbox # Sandbox doesn't do scheduled shutdowns. Maybe this should test for prodpci?
        echo "$fork_env""aws-vault exec $aws_profile -- ansible-playbook -i $env deploy-payrix-api-0-schedule-shutdown.yml"
    end
    echo "$fork_env""aws-vault exec $aws_profile -- ansible-playbook -i $env deploy-payrix-api-1-shutdown.yml"
    echo "$fork_env""aws-vault exec $aws_profile -- ansible-playbook -i $env deploy-payrix-api-2-execute-deployment.yml"
    echo
end
