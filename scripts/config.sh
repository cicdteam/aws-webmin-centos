#!/bin/bash

if [ -z $1 ]; then NAME="www.example.com"; else NAME=$1; fi
if [ -z $2 ]; then PASS="examplepassword"; else PASS=$2; fi

# Wait while Cloud-init finished
while [ ! -e /run/cloud-init/result.json ]; do
  echo "Waiting while Cloud-Init finished..."; sleep 10
done

echo; echo "Install Virtualmin"; echo

die () {
  echo "ERROR: $1. Aborting!"
  exit 1
}

echo -n "Update system and kernel, wait little bit... " && \
sudo yum -y -q update >/dev/null 2>&1 && \
sudo yum -y -q upgrade >/dev/null 2>&1 && \
sudo yum -y -q install linux-image-extra-$(uname -r) >/dev/null 2>&1 && \
sudo yum -y -q update >/dev/null 2>&1 && \
echo "updated."

echo -n "Install virtualmin for $NAME " && \
sudo yum -y -q install perl >/dev/null 2>&1 && \
curl -sSL http://software.virtualmin.com/gpl/scripts/install.sh -o /tmp/install.sh >/dev/null 2>&1 && \
sudo sh /tmp/install.sh -f --hostname $NAME >/dev/null 2>&1 && \
sudo /usr/libexec/webmin/changepass.pl /etc/webmin root $PASS >/dev/null 2>&1 && \
sudo sed -ie "s/ssl=1/ssl=0/" /etc/webmin/miniserv.conf >/dev/null 2>&1 && \
sudo service webmin restart >/dev/null 2>&1 && \
echo "...installed" || die "problem with Virtualmin"

echo "Cleanup"
sudo yum -y -q clean all >/dev/null 2>&1

echo "Done!"
