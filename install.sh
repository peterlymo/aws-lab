# Created By peterlymo | malwarepeter 06/06/2023

#!/bin/bash
echo "--------------------------------"
echo -e "\032[1;33mCreated By peterlymo            |"
echo "--------------------------------"


if [ -z "$1" ]
  then
    echo "Please put your RDS endpoint"
    exit 1
elif [ -z "$2" ]
  then
    echo "Please put ACCESS KEY"
    exit 1
elif [ -z "$3" ]
  then
    echo "Please put your SECRET KEY"
    exit 1
elif [ -z "$4" ]
  then
    echo "Please put your S3 region"
    exit 1
elif [ -z "$5" ]
  then
    echo "Please put your S3 Bucket Name"
    exit 1
elif [ -z "$6" ]
  then
    echo "Please put your RDS DB Username"
    exit 1
elif [ -z "$7" ]
  then
    echo "Please put your RDS DB Password"
    exit 1
elif [ -z "$8" ]
  then
    echo "Please put your RDS DB Name"
    exit 1
fi


echo "-------starting installing------"
sudo apt-get --yes update
sudo apt install --yes python3-pip python3-dev python3-venv nginx mysql-client
python3 -m venv env
source env/bin/activate
pip3 install -r requirement.txt
deactivate
sudo service nginx start
sudo service nginx stop
sed -i "s?CREATE DATABASE .*?CREATE DATABASE IF NOT EXISTS \`$8\` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;?" db.sql
sed -i "s?USE .*?USE \`$8\`;?" db.sql
mysql -h $1 -u $6 -P 3306 --password=$7 < db.sql

sed -i "s?DB_HOST=.*?DB_HOST=\"$1\"?" app.py
sed -i "s?AWS_ACCESS_KEY_ID=.*?AWS_ACCESS_KEY_ID=\"$2\"?" app.py
sed -i "s?AWS_SECRET_ACCESS_KEY=.*?AWS_SECRET_ACCESS_KEY=\"$3\"?" app.py
sed -i "s?REGION=.*?REGION=\"$4\"?" app.py
sed -i "s?AWS_BUCKET_NAME=.*?AWS_BUCKET_NAME=\"$5\"?" app.py
sed -i "s?DB_USER=.*?DB_USER=\"$6\"?" app.py
sed -i "s?DB_PASSWORD=.*?DB_PASSWORD=\"$7\"?" app.py
sed -i "s?DB_NAME=.*?DB_NAME=\"$8\"?" app.py


ip=$(curl http://169.254.169.254/latest/meta-data/public-ipv4)
sed -i "s?server_name .*?server_name $(echo $ip);?" aws-app.conf
sed -i "s?proxy_pass http://unix:.*?proxy_pass http://unix:$(pwd)/aws-app.sock;?" aws-app.conf
sed -i "s?WorkingDirectory=.*?WorkingDirectory=$(pwd)?" aws-app.service
sed -i "s?ExecStart=.*?ExecStart=$(pwd)/env/bin/gunicorn --workers 3 --bind unix:$(pwd)/aws-app.sock -m 777 wsgi:app?" aws-app.service
sudo rm -r /etc/nginx/sites-enabled/aws-app.conf
sudo rm -r /etc/systemd/system/aws-app.service
sudo ln -s $(pwd)/aws-app.service /etc/systemd/system
sudo ln -s $(pwd)/aws-app.conf /etc/nginx/sites-enabled
sudo chgrp www-data /home/$USER

sudo systemctl daemon-reload
sudo systemctl start aws-app
sudo systemctl restart aws-app
sudo systemctl restart nginx

echo "-------Done!!!!!!------"
echo -e "\033[1;33mSNow visit http://$ip  ...."
