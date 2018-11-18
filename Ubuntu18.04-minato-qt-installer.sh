echo "Checking if script is run with sudo or root user"
if [ `id -u` = 0 }
then
   echo "Root privileges verified. Resuming installation"
else
   echo "Please, run the script with root privileges" && exit
fi
echo "Checking if default version of libssl-dev is installed. Required libssl1.0-dev"
dpkg -s libssl-dev | grep Status
if [ $? = 0 ] 
then
   echo "Wrong libssl-dev version."
   echo "Please run the following command and run the install script again"
   echo "sudo apt-get remove --purge libssl-dev"
   exit
fi

apt-get -y install build-essential libssl1.0-dev libdb-dev libdb++-dev libboost-all-dev git libdb-dev libdb++-dev libboost-all-dev libminiupnpc-dev libevent-dev libcrypto++-dev libgmp3-dev libminiupnpc-dev qt4-default libzmq3-dev
if [ $? != 0 ]
then
   echo "Some packages have failed, please check"
   exit
fi
echo "Checking if correct version of libssl-dev is installed. Required libssl1.0-dev"
dpkg -s libssl1.0-dev | grep Status
if [ $? != 0 ] 
then
   echo "Wrong libssl-dev version."
   echo "Please run the following command and run the install script again"
   echo "sudo apt-get remove --purge libssl-dev"
   exit
else
   echo "libssl-dev version. Beggining packages and dependencies needed installation"
fi
add-apt-repository -y ppa:bitcoin/bitcoin 
if [ $? != 0 ]
then
   echo "Couldn't add repository. Exiting" && exit
fi
apt-get install -y libdb4.8-dev libdb4.8++-dev 
if [ $? != 0 ]
then
   echo "Installation of Berkeley 4.8 or failed. Exiting" && exit
fi
git clone https://github.com/minato-project/minato.git
cd minato
chmod -R +rwx *
qmake "USE_UPNP=1" minato-qt.pro 
make -f Makefile
if [ $? -eq 0 ] 
then
   echo "Compilation correct"
else
   echo "Compilation failure"
fi
