function payrix-amq --description="List AMQ dashboard URLs for current AWS profile"
    set -f brokers (aws mq list-brokers --query 'BrokerSummaries[].BrokerId' | jq -r '.[]')

    for broker in $brokers
        set -f description (aws mq describe-broker --broker-id $broker)
        set -f console_urls (echo $description | jq -r '.BrokerInstances[].ConsoleURL')
        set -f name (echo $description | jq -r '.BrokerName')

        echo $name
        for console_url in $console_urls
            echo "    $console_url"
        end
    end
end
