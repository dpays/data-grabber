#!/bin/bash

cd $HOME

# if a previous snapshot.json exists, delete it
rm -rf snapshot.json

echo snapshot-generator: installing tinman

git clone https://github.com/steemit/tinman
virtualenv -p $(which python3) ~/ve/tinman
source ~/ve/tinman/bin/activate
cd tinman
pip install pipenv && pipenv install
pip install .

cd $HOME

timestamp=$(date +%s)

echo snapshot-generator: generating a new snapshot.json file

tinman snapshot -s https://api.steemit.com -o snapshot.json

echo snapshot-generator: copying snapshot-$timestamp.json to s3://$S3_BUCKET
aws s3 cp snapshot.json s3://$S3_BUCKET/snapshot-$timestamp.json
echo snapshot-generator: copying to snapshot.json
aws s3 cp s3://$S3_BUCKET/snapshot-$timestamp.json s3://$S3_BUCKET/snapshot.json

echo snapshot-generator: waiting 24 hours before running again
sleep 86400
