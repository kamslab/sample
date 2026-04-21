#!/bin/bash
TOKEN=$(curl -s -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")


ID=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/instance-id)
PUB_IP=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/public-ipv4)
PRIV_IP=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/local-ipv4)
SG=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/security-groups)

OS=$(grep "PRETTY_NAME" /etc/os-release | cut -d'"' -f2)

USERS=$(grep -E '/bin/(bash|sh)$' /etc/passwd | cut -d: -f1 | xargs | sed 's/ /, /g')

cat <<EOF > info.txt
Instance ID: $ID
Public IP: $PUB_IP
Private IP: $PRIV_IP
Security Groups: $SG
Operating System: $OS
Shell Users: $USERS
EOF

aws s3 cp info.txt s3://applicant-task/instance-109/info.txt


