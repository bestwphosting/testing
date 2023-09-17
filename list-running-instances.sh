#!/bin/bash
REGIONS=$(aws ec2 describe-regions)
for REGION in $(echo $REGIONS | jq -r '.Regions[].RegionName'); do
  echo "REGION: $REGION";
  aws ec2 --region $REGION describe-instances --filters Name=instance-state-code,Values=0,16,32,64,80 --query 'Reservations[].Instances[].InstanceId';
done
