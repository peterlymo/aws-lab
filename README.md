
# What's new
I have Updated AWS architecture 2 to support new technologies and easy setup, where it originally was from https://github.com/thejungwon/AWS/ 

# added supports 
- python3
- boto3
- refactored and remove unnecessary code

# AWS Services
- EC2
- RDS
- S3

# prerequisites

- EC2-server with ports firewall allowed to be accessed
- S3 bucket with security policies allowed to be accessed, get S3 REGION 
- RDS database created to get username, password, and database name and rds endpoint
- allow inbound traffic in RDS so RDS endpoint can be accessed
- security credentials for accessing aws services, including ACCESS_KEY AND SECRET_KEY

my s3 bucket policy configuration, modify to meet your needs

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": "*",
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:DeleteObject"
            ],
            "Resource": "arn:aws:s3:::yourbucketname/*"
        },
        {
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:ListBucket",
            "Resource": "arn:aws:s3:::yourbucketname"
        }
    ]
}
```

# How To Run
```
bash install.sh <RDS_ENDPOINT> <ACCESS_KEY> <SECRET_KEY> <S3_REGION> <S3_BUCKET_NAME> <RDS_SD_USERNAME> <RDS_DB_PASSWORD> <RDS_DB_NAME> 
```
example 

```
bash install.sh cp424.c8jbakfloyel.us-east-1.rds.amazonaws.com AKIAQU*********** 7xTQPLfOhoL+**************** us-east-1 cp-424-s3 admin pass**** cp424db

```

you are good to go, sometimes things may work as expected, I assume you are an engineer,so google is your friend

# Architecture
![Architecture](../static/target_architecture_2.png)

