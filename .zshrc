function awsprofile() {
    local profile="$1"
    if grep "\[profile $profile\]" ~/.aws/config > /dev/null; then
        export AWS_PROFILE="$profile"
        if ! aws sts get-caller-identity 2>/dev/null >/dev/null; then
            aws sso login --profile "$profile"
        fi
    else
        unset AWS_PROFILE
        if [ ! "$profile" == "unset" ]; then
            echo >&2 "No AWS profile with name $profile. Unsetting for safety."
            echo >&2 "(prod or staging, probably)"
            return 1
        fi
    fi
}

alias awsp="awsprofile"

function kubecontext() {
    local profile="$1"
    if kubectl config get-contexts -o name | grep "^$profile$" > /dev/null; then
        kubectl config use-context "$profile" > /dev/null
    else
        kubectl config unset current-context > /dev/null
        if [ ! "$profile" == "unset" ] && [ ! "$profile" == "eks-unset" ]; then
            echo >&2 "No Kubernetes context with name $profile. Unsetting for safety"
            return 1
        fi
    fi
}

alias kubep=kubecontext

function usecloud() {
    local profile="$1"
    awsprofile "$profile"
    kubecontext "eks-$profile"
}
