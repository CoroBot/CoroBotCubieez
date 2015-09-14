# This bash file takes the standard Lubuntu installation on a Cubieboard 4 (CC-A80)
# and configures it with the required CoroBot Software including ROS and additional
# robotics oriented tools. 

# This script is designed to be run directly on the CC-A80 running Lubuntu 14.04

# Developer: CoroWare Robotics Solutions <www.corobot.net>
# Author: Cameron Owens <cowens@coroware.com>

# Version 0.01
# Date: August 31, 2015

# Setting up Script Colors

ESC_SEQ='\x1b['
COL_RESET=$ESC_SEQ"39;49;00"
COL_RED=$ESC_SEQ"31;01m"
COL_CYAN=$ESC_SEQ"36;01m"
COL_GREEN=$ESC_SEQ"32;01m"
COL_WHITE=$ESC_SEQ"37;01m"

VER="0.01"

echo -n -e "
$COL_WHITE Welcome to the $COL_RED CoroBot Cubieez $COL_WHITE setup utility tool Ver $VER developed by $COL_RED CoroWare Robotics Slutions $COL_WHITE . This tool is designed to take the standard Lubuntu installation on the Cubieboard CC-A80 and install all of the required tools to use the CoroBot Softawre.

Please review the compiled license agreement and $COL_RED BACK UP ALL SENSITIVE DATA!! $COL_WHITE CoroWare Robotics Solutions is NOT responsible for any lost or damaged data. 

Please, press "ENTER" to continue

>>>"
	read dummy
	more <<EOF

===============================================
CoroBot CUBIEEZ Setup Tool Information
===============================================

The following software packages will be installed 

* OpenCV
* ROS
* Python Developer Tools (Cython, HIDAPI, etc)
* CoroBot Github Repos including the CoroBot ROS Stack, CoroBot Unity Board API, etc

EOF
echo -e $COL_RED"
Are you ready to install? $COL_CYAN Type [YES|NO]:>>>"
read ans
	if [[ ($ans != "yes") && ($ans != "YES") && ($ans != "Yes") && ($ans != "y") && ($ans != "Y") ]]
	then
		echo "Aborting the Configuration Process.... Try again"
		exit 2
	fi
	echo -n -e "
	$COL_GREEN
The CoroBot Cubieez setup tool will begin the configuration process"
echo $COL_CYAN"Running Software Updates and Upgrades"
echo $COL_WHITE
sudo apt-get update && sudo apt-get upgrade -y 

echo $COL_CYAN "Creating a Downlaods Directory"
$COL_WHITE
mkdir ~/Downloads
ls ~/
echo $COL_CYAN "Installing Preliminary Tools and Packages"
$COL_WHITE
sudo apt-get install build-essential vim emacs screen checkinstall subversion python-pip ipython3 ipython3-notebook python-zmq
clear

echo $COL_CYAN "Installing Libsodioum as a pre-req for ZMQ"
$COL_WHITE
cd ~/Downloads
wget https://download.libsodium.org/libsodium/releases/LATEST.tar.gz
tar -zxvf LATEST.tar.gz
cd libsodium*
./configure
make && sudo make check
sudo make install

echo $COL_CYAN "Getting ZMQ Messaging Tools"
$COL_WHITE
cd ~/Downloads
wget http://download.zeromq.org/zeromq-4.1.3.tar.gz
tar -zxvf zeromq-4.1.3.tar.gz
cd zeromq-4.1.3
./configure
make && sudo make check
sudo make install
sudo ldconfig
echo $COL_RED "Exiting Downloads Folder"
cd ~/
clear

echo $COL_CYAN "Installing Python related tools and dependencies"
echo $COL_WHITE
sudo apt-get install python3 python3-pyside python3-all-dev python3-zmq libzmq-dev python3-dev libusb-1.0-0-dev libudev-dev python3-dev -y
clear
echo $COL_CYAN "Getting PIP; the Python install manager"
echo $COL_WHITE
cd ~/Downloads
wget https://bootstrap.pypa.io/get-pip.py
sudo python3 get-pip.py
sudo pip3 install numpy virtualenv virtualenvwrapper pyzmq cython
sudo pip3 install hidapi

echo $COL_CYAN "Installing OpenCV 3.0.0"
echo $COL_WHITE
sudo apt-get install cmake libjpeg8-dev libtiff4-dev libjasper-dev libpng12-dev libgtk2.0-dev libavcodec-dev libavformat-dev libswscale-dev libv4l-dev libatlas-base-dev gfortran -y

cd ~/
git clone https://github.com/Itseez/opencv.git --depth 2
cd opencv
git checkout 3.0.0
cd ~/
git clone https://github.com/Itseez/opencv_contrib.git --depth2
cd opencv_contrib
git checkout 3.0.0
cd ~/opencv
mkdir build
cd build

cmake -D CMAKE_BUILD_TYPE=RELEASE \
      -D CMAKE_INSTALL_PREFIX=/usr/local \
      -D INSTALL_C_EXAMPLES=ON \
      -D INSTALL_PYTHON_EXAMPLES=ON \
      -D OPENCV_EXTRA_MODULES_PATH=~/opencv_contrib/modules \
      -D BUILD_EXAMPLES=ON ..
make -j4
sudo make install
sudo ldconfig

echo $COL_CYAN "Verifying OpenCV is in Python3 Path"
echo $COL_RED 
ls -l /usr/local/lib/python3.2/site-packages
sleep 5

echo $COL_CYAN "Installing Developer Tools"
echo $COL_WHITE
sudo apt-get intstall emacs vim nmap screen

echo $COL_CYAN "Getting ROS Indigo for ARM"
echo $COL_WHITE
sudo update-locale LANG=C LANGUAGE=C LC_ALL=C LC_MESSAGES=POSIX
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu trusty main" > /etc/apt/sources.list.d/ros-latest.list'

wget https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -O - | sudo apt-key add -

sudo apt-get update
sudo apt-get install ros-indigo-ros-base

sudo apt-get install python-rosdep
sudo rosdep init
rosdep update
echo "source /opt/ros/indigo/setup.bash" >> ~/.bashrc
source ~/.bashrc

sudo apt-get install python-rosinstall

echo "Getting CoroBot ROS Metapackage"
cd ~/
git clone https://github.com/CoroBot/CoroBot_ROS
cd CoroBot_ROS/src
catkin_init_workspace
cd ..
catkin_make

echo "Adding CoroBot ROS Stack to Sources"
echo "source ~/CoroBot_ROS/devel/setup.bash" >> ~/.bashrc

