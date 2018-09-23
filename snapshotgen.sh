#!/bin/bash

cd $HOME

# if a previous snapshot or actions list exists, delete it
rm -rf snapshot.json
rm -rf txgen-latest.list

echo snapshot-generator: installing tinman

git clone https://github.com/steemit/tinman
virtualenv -p $(which python3) ~/ve/tinman
source ~/ve/tinman/bin/activate
cd tinman
pip install pipenv && pipenv install
pip install .

cd $HOME

cp $HOME/tinman/txgen.conf.example $HOME/txgen.conf

timestamp=$(date +%s)

echo snapshot-generator: generating a new snapshot.json file

tinman snapshot -s https://api.steemit.com -o snapshot.json

echo snapshot-generator: generating a new txgen-latest.list

tinman txgen -c txgen.conf -o txgen-latest.list

echo snapshot-generator: copying txgen-$timestamp.json to s3://$S3_BUCKET
aws s3 cp txgen-latest.list s3://$S3_BUCKET/txgen-$timestamp.list
echo snapshot-generator: copying to txgen-latest.list
aws s3 cp s3://$S3_BUCKET/txgen-$timestamp.list s3://$S3_BUCKET/txgen-latest.list

echo snapshot-generator: waiting 24 hours before running again
sleep 86400
