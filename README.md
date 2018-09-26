# Data Grabber

Simple tool to generate a snapshot daily for consumption of dPay testnets. The snapshot will live in an AWS S3 bucket.

Requirements: environment variable $S3_BUCKET must be set and an IAM Role that has access to this bucket must be applied to the instance running it.

usage: `docker run -d --env S3_BUCKET=bucket-name dpays/data-grabber:latest`
