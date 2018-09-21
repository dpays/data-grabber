#!/bin/bash

cd $HOME

git clone https://github.com/steemit/tinman
virtualenv -p $(which python3) ~/ve/tinman
source ~/ve/tinman/bin/activate
cd tinman
pip install pipenv && pipenv install
pip install .

cd $HOME

timestamp=$(date +%s)

tinman snapshot -s https://api.steemit.com -o snapshot.json
aws s3 cp snapshot.json s3://$S3_BUCKET/snapshot-$timestamp.json
aws s3 cp s3://$S3_BUCKET/snapshot-$timestamp.json s3://$S3_BUCKET/snapshot-latest.json