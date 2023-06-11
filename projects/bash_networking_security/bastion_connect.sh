#!/bin/bash

PUBLIC_INSTANCE_IP=$1
PRIVATE_INSTANCE_IP=$2
COMMAND=$3


if [[ -z "${KEY_PATH+x}" ]]; then
	echo "KEY_PATH env var is expected";
fi

if [[ -z "${PUBLIC_INSTANCE_IP}" ]]; then
	echo "Please provide bastion IP address";
fi

if [ $# -eq 1 ]; then
  ssh -i "$KEY_PATH" "ubuntu@$PUBLIC_INSTANCE_IP"
elif [ $# -eq 2 ]; then
  ssh -i "$KEY_PATH" "ubuntu@$PUBLIC_INSTANCE_IP" ssh -i "~/work/bootcamp.pem" -tt "ubuntu@$PRIVATE_INSTANCE_IP"
elif [ $# -eq 3 ]; then
  ssh -i "$KEY_PATH" "ubuntu@$PUBLIC_INSTANCE_IP" ssh -i "~/work/bootcamp.pem" -tt "ubuntu@$PRIVATE_INSTANCE_IP" "$COMMAND"
else
  echo "Invalid number of arguments."
fi


