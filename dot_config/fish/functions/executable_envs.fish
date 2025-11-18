function envs --description="Evaluate a bash-like environment variables file"
    set -gx (cat $argv | tr "=" " " | string split ' ')
end
