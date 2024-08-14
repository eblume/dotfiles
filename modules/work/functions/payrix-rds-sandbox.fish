set -f host "payrix-sandbox-rds-proxy.proxy-cfv6yjj08qvp.us-east-1.rds.amazonaws.com"
set -f psql_command "psql -h $host -d payrix -U payrixroot -p 5432"
echo $psql_command | pbcopy
echo "psql command (copied to clipboard): $psql_command"
aws-vault exec payrix-sandbox -- ssh payrix-sandbox-api
