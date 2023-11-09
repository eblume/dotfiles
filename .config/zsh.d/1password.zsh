export OP_BIOMETRIC_UNLOCK_ENABLED=true

# ssh-agent key loading: load ssh key from 1password if it's not already loaded and if it's safe to do so
function () {  # anonymous function, executes once and then unfuncs itself
    local fingerprint="SHA256:Cd7uCMYhbDqZ09P3fAkf6tFdj8dWmwbWs8kk2skVNpw"
    local keys
    local found=0
    if [[ -z "$SSH_AUTH_SOCK" ]]; then
        echo "ssh-agent is not running, not loading ssh key"
        return
    fi

    for key in "${(@f)$(ssh-add -l)}"; do
        if [[ $key == *"$fingerprint"* ]]; then
            found=1
            break
        fi
    done

    if [[ $found -eq 1 ]]; then
        # ssh key found, just silently return - the happy path.
        return
    fi

    if ! command -v op &> /dev/null; then
        echo "1password is not installed, not loading ssh key"
        return
    fi

    # Detect if user is connecting via ssh and if so, don't load the key.
    if [[ -n $SSH_CONNECTION ]]; then
        echo "ssh connection detected, not loading ssh key to avoid blocking login."
        echo "You may need to run the following command to load your key:"
        echo "    op item --vault personal get 'SSH - Personal' --fields 'Private Key' --reveal | tr -d '\r' | sed '1d; $d' | ssh-add -"
        echo 
        echo "    # Might also be useful, not sure if it can work headless:"
        echo "    op signin"
        echo "(Sleeping for 2 seconds to allow you to read this message)"
        sleep 2
        return
    fi

    # Finally, it's safe to load the key
    echo "Loading ssh key from 1password"

    item=$(op item --vault personal get 'SSH - Personal' --fields 'Private Key' --reveal)
    if [[ $? -ne 0 ]]; then
        echo "Failed to load ssh key from 1password"
        return
    fi

    echo $item | tr -d '\r' | sed '1d; $d' | ssh-add -
    if [[ $? -ne 0 ]]; then
        echo "Failed to load ssh key from 1password"
        return
    fi
}
