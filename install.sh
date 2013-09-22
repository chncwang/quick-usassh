#/bin/bash

zip_name=obfuscated-openssh.zip
wget http://www.123ssh.com/$zip_name
unzip obfuscated-openssh.zip
rm $zip_name

openssh_name=obfuscated-openssh
chmod -Rc 755 $openssh_name
cd $openssh_name
sudo apt-get install -y make
./configure --prefix=/usr --sysconfdir=/etc/ssh
make
sudo make install

cd ..
rm -rf $openssh_name

file_path=/usr/local/bin/quick-usassh
sudo cp ./quick-usassh.plx $file_path
sudo chmod a+x $file_path
