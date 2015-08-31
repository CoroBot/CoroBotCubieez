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
$COL_GREEN
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
