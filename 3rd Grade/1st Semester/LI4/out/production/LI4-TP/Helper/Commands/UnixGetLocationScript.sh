#!/bin/sh
#curl --version
#jq --version
ip=$(curl -s https://ipinfo.io/ip)
#echo $ip
json=$(curl -s curl https://ipinfo.io/$ip)
result=$(echo "$json" | jq .loc )

echo "$result"