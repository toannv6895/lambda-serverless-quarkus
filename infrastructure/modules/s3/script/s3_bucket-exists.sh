#!/bin/bash

# Exit if any of the intermediate steps fail
set -e

# Extract "bucket_name" argument from the input into BUCKET_NAME shell variable.
# jq will ensure that the value is properly quoted and escaped for consumption by the shell.
BUCKET_NAME=$(jq -r '.bucket_name' <<< "$1")
# Check if the S3 bucket exists
# if aws s3 ls "s3://$BUCKET_NAME" 2>&1 | grep -q "NoSuchBucket"; then
#     EXISTS=false
# else
#     EXISTS=true
# fi

BUCKET_EXISTS=$(aws s3api head-bucket --bucket $BUCKET_NAME 2>&1 || true)
if [ -z "$BUCKET_EXISTS" ]; then
  EXISTS=true
else
  EXISTS=false
fi

# Output the result as JSON
jq -n --arg exists "$EXISTS" '{"exists":$exists}'