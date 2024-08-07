set -l security_group_id sg-96ee37de
set -l protocol tcp
set -l port 2202
set -l description "Erich Blume IP Whitelist"
set -l current_ip (curl -s  https://ipinfo.io/ip)
set -l region us-east-1

function exec_aws
    aws-vault exec payrix-pci -- aws $argv
end

set -l group_info (exec_aws ec2 describe-security-groups --group-ids $security_group_id --region $region)
set -l permissions (echo $group_info | jq '.SecurityGroups[0].IpPermissions')
set -l ssh_permission (echo $permissions | jq '.[] | select(.FromPort == '$port' and .IpProtocol == "'$protocol'")')

if test -z "$ssh_permission"
    echo >&2 "Error: $security_group_id does not contain the specified ingress"
    echo >&2 "Is it possible the security group changed or your failed to log in?"
    exit 1
end

set -l current_entry (echo $ssh_permission | jq -c '.IpRanges[] | select(.Description == "'$description'")')

if ! test -z "$current_entry"
    set -l entry_cidr (echo $current_entry | jq '.CidrIp')

    if test -z "$entry_cidr"
        echo >&2 "Can't parse out valid CIDR info:"
        echo >&2 "$group_info"
        exit 1
    end

    # If the CidrIp has'nt changed just echo a happy message
    if [ "$entry_cidr" = "$current_ip/32" ]
        echo "Nothing to do, IP remains $current_ip"
        exit 0
    end

    # Remove the existing entry
    exec_aws ec2 revoke-security-group-ingress --region $region --group-id $security_group_id --ip-permissions FromPort=$port,ToPort=$port,IpProtocol=$protocol,IpRanges="[{CidrIp=$entry_cidr}]"

end

# Finally, (re)append the new entry:
exec_aws ec2 authorize-security-group-ingress --region $region --group-id $security_group_id --ip-permissions FromPort=$port,ToPort=$port,IpProtocol=$protocol,IpRanges="[{CidrIp=$current_ip/32,Description='$description'}]"

# PostScript: echo the new entry
set -l new_entry (exec_aws ec2 describe-security-groups --group-ids $security_group_id --region $region | jq ".SecurityGroups[0].IpPermissions[] | select(.FromPort == $port and .IpProtocol == \"$protocol\").IpRanges[] | select(.Description == \"$description\")")

if test -z "$new_entry"
    echo >&2 "After script ran, found no entry, something broke!"
    exit 1
else
    echo "Success:"
    echo "$new_entry"
end
