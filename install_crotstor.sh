#!/bin/bash

#################################################################################
# This Script Builds The CrotStor software To Help Migrate Data To S3 Buckets   #
# By acting as an appliance to automatically move data                          #
# From local shared storage to S3 Buckets                                       #
#################################################################################         

####Script To Gather Info For Variables During Installation####

##Check To Ensure Script Is Being Run As Root##

if [[ $EUID -ne 0 ]]; then
whiptail --title "Check Root User" --msgbox "This Script MUST BE RUN AS ROOT. Please Re-Run as root user. Choose Ok to continue." 10 60
   exit 1
fi

whiptail --title "CrotStor Configuration Confirmation" --msgbox "You are configuring the CrotStor Cloud Archive Appliance. Choose Ok to continue." 10 60

#####################################
##Getting S3 Access Key Information##
#####################################

whiptail --title "S3 Security Information" --msgbox "A Browser Will Now Open. Please Log In And Copy Your Key Information. Close Browser to Continue. Click Ok to open browser." 10 60

firefox https://aws-portal.amazon.com/gp/aws/securityCredentials &

ACCESS_KEY_ID=$(whiptail --title "Access Key Input Form" --inputbox "What is your AWS S3 Secret Access Key?" 10 60  3>&1 1>&2 2>&3)

exitstatus=$?
if [ $exitstatus = 0 ]; then
whiptail --title "Your S3 Access Key ID" --msgbox "Your S3 ACCESS Key is $ACCESS_KEY_ID.  Choose Ok to continue." 10 60

else
    echo "You chose Cancel."
fi

SECRET_ACCESS_KEY=$(whiptail --title "SECRET ACCESS KEY Form" --inputbox "What is your AWS S3 Secret Access Key?" 10 60  3>&1 1>&2 2>&3)

exitstatus=$?
if [ $exitstatus = 0 ]; then
whiptail --title "Your S3 Secret Access Key" --msgbox "Your S3 ACCESS Key is $SECRET_ACCESS_KEY.  Choose Ok to continue." 10 60

else
    echo "You chose Cancel."
fi

##Getting S3 Bucket Name##

S3_BUCKET_NAME=$(whiptail --title "S3 Bucket Name Form" --inputbox "What is your AWS S3 Bucket Name?" 10 60  3>&1 1>&2 2>&3)

exitstatus=$?
if [ $exitstatus = 0 ]; then
whiptail --title "Your S3 Bucket Name" --msgbox "Your S3 Bucket Name Is $S3_BUCKET_NAME.  Choose Ok to continue." 10 60

else
    echo "You chose Cancel."
fi

##Now starting to actually do the install##

echo $ACCESS_KEY_ID:$SECRET_ACCESS_KEY > /etc/passwd-s3fs
chmod 640 /etc/passwd-s3fs

##Install FUSE and S3FS and dependencies##
##Remove Old Versions##
yum remove fuse fuse-s3fs

##Install Dependencies##

yum install -y gcc libstdc++-devel gcc-c++ curl-devel libxml2-devel openssl-devel mailcap fuse-libs

##Download and Compile Code##

cd /usr/src/
wget http://downloads.sourceforge.net/project/fuse/fuse-2.X/2.9.3/fuse-2.9.3.tar.gz
tar xzf fuse-2.9.3.tar.gz
cd fuse-2.9.3
./configure --prefix=/usr/local
make && make install
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig
ldconfig
modprobe fuse

cd /usr/src/
wget https://s3fs.googlecode.com/files/s3fs-1.74.tar.gz
tar xzf s3fs-1.74.tar.gz
cd s3fs-1.74
./configure --prefix=/usr/local
make && make install

##Creating Mount Points##

mkdir /tmp/cache
mkdir /s3mnt
chmod 777 /tmp/cache /s3mnt

##Mounting S3 Bucket##

s3fs -o use_cache=/tmp/cache crotstor /s3mnt

whiptail --title "CrotStor Configuration Confirmation" --msgbox "You Have Completed Configuration of the CrotStor Cloud Archive Appliance. Choose Ok to exit installation Script!!" 10 60

exit 0
