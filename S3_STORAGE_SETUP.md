# NetBox S3 Storage Backend Setup

This document describes how to configure NetBox to use Amazon S3 as a remote storage backend for file uploads.

## Changes Made

1. **Dockerfile**: The Dockerfile already includes django-storages with boto3 support (see line 37).

2. **Configuration**: Added S3 storage backend configuration in `configuration/extra.py`:
   ```python
   STORAGE_BACKEND = 'storages.backends.s3boto3.S3Boto3Storage'
   STORAGE_CONFIG = {
       'AWS_ACCESS_KEY_ID': os.environ.get('AWS_ACCESS_KEY_ID', ''),
       'AWS_SECRET_ACCESS_KEY': os.environ.get('AWS_SECRET_ACCESS_KEY', ''),
       'AWS_STORAGE_BUCKET_NAME': os.environ.get('AWS_STORAGE_BUCKET_NAME', 'netbox'),
       'AWS_S3_REGION_NAME': os.environ.get('AWS_S3_REGION_NAME', 'us-east-1'),
   }
   ```

3. **Environment Variables**: Added AWS credentials to `env/netbox.env`:
   - `AWS_ACCESS_KEY_ID`
   - `AWS_SECRET_ACCESS_KEY`
   - `AWS_STORAGE_BUCKET_NAME`
   - `AWS_S3_REGION_NAME`

## Setup Instructions

1. **Configure AWS Credentials**:
   Edit `env/netbox.env` and replace the placeholder values with your actual AWS credentials:
   ```bash
   AWS_ACCESS_KEY_ID=your-actual-access-key-id
   AWS_SECRET_ACCESS_KEY=your-actual-secret-access-key
   AWS_STORAGE_BUCKET_NAME=your-actual-bucket-name
   AWS_S3_REGION_NAME=your-bucket-region
   ```

2. **Create S3 Bucket**:
   Ensure your S3 bucket exists and has the appropriate permissions for the IAM user whose credentials you're using.

3. **Test Locally**:
   ```bash
   docker-compose up -d
   ```

4. **Build Custom Image**:
   ```bash
   docker build -t your-registry/netbox:custom .
   ```

5. **Push to Registry**:
   ```bash
   docker push your-registry/netbox:custom
   ```

## Required S3 Bucket Permissions

The IAM user needs the following permissions on the S3 bucket:
- `s3:PutObject`
- `s3:GetObject`
- `s3:DeleteObject`
- `s3:ListBucket`

Example IAM policy:
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:DeleteObject"
            ],
            "Resource": "arn:aws:s3:::your-bucket-name/*"
        },
        {
            "Effect": "Allow",
            "Action": "s3:ListBucket",
            "Resource": "arn:aws:s3:::your-bucket-name"
        }
    ]
}
```

## Verification

After deployment, you can verify the S3 storage is working by:
1. Logging into NetBox
2. Uploading an image attachment to a device or other object
3. Checking your S3 bucket to confirm the file was uploaded