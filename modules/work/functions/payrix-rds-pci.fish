set -f host "http://prod-payrix-replica-3.cvzqqve8hxw0.us-east-1.rds.amazonaws.com/"
set -f psql_command "psql -h $host -d payrix -U payrixroot -p 5432"
echo $psql_command | pbcopy
echo "psql command (copied to clipboard): $psql_command"
aws-vault exec payrix-pci -- ssh payrix-jobs-dev
