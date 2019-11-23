#!/bin/bash


######################################################################################################################################################
# File          : gitlab_runner_upgrade.sh
# Author        : Inderpal Singh Saini <inderpal2406@gmail.com>
# Created       : 23 Sept, 2019
# Updated       : 27 Sept, 2019
# Description   : This script will upgrade gitlab-runner to latest available version.
######################################################################################################################################################


# Defining text colors
RED='\033[0;31m'	# defining red color
OR='\033[0;33m'		# defining orange color
GR='\033[0;32m'		# defining green color
NC='\033[0m' 		# defining no color


# Defining variables
BACKUP_DIR=/root/gitlab-runner-backup
CURRENT_VERSION=`/usr/local/bin/gitlab-runner -v | grep Version | awk '{print $2}'`
RUNNER_BINARY=/usr/local/bin/gitlab-runner


#Defining functions
error()
{
	echo
	echo -e "${RED}Operation failed!${NC}"
	echo
	echo "Exiting script. Please try the operation manually."
	echo
	exit 1
}
success()
{
	echo
	echo -e "${GR}Operation successful!${NC}"
	echo
	echo "Press ENTER to proceed."
	echo
	read
}


# Code starts here


clear	# clear screen


# Display message to pause runner in GitLab GUI before upgrade.
echo -e "Before upgrading gitlab runner, ${RED}it is mandatory to PAUSE${NC} the runner in GitLab GUI."
echo
echo -e "If runner is not paused, then press ${RED}CTRL+C${NC} to exit. Then re-run the script after pausing the runner."
echo
echo -e "If runner is paused, then press ${GR}ENTER${NC} to proceed."
read
echo


echo -e "Current gitlab-runner version is ${OR}$CURRENT_VERSION${NC}. It'll be upgraded to latest available version."
echo
echo "Press ENTER to start the upgrade."
read;
echo


echo "Taking backup of current gitlab-runner binary as $BACKUP_DIR/gitlab-$CURRENT_VERSION.tar.gz"
sleep 2
if ! [[ -d $BACKUP_DIR ]]
then
	mkdir $BACKUP_DIR
fi
cd /usr/local/bin/
tar -czf $BACKUP_DIR/gitlab-$CURRENT_VERSION.tar.gz gitlab-runner 2>/dev/null 1>/dev/null
if [ $? -ne 0 ]
then
	error
else
	success
fi


echo "Stopping gitlab runner."
sleep 2
$RUNNER_BINARY stop > /dev/null 2>&1
if [ $? -ne 0 ]
then
	error
else
	success
fi


echo "Downloading latest gitlab-runner binary."
curl -L --output $RUNNER_BINARY https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-amd64 > /dev/null 2>&1
if [ $? -ne 0 ]
then
	error
else
	success
fi


echo "Giving execute permissions to new downloaded gitlab-runner binary."
sleep 2
chmod +x $RUNNER_BINARY > /dev/null 2>&1
if [ $? -ne 0 ]
then
	error
else
	success
fi


echo "Verfifying new version."
sleep 2
NEW_VERSION=`$RUNNER_BINARY -v | grep Version | awk '{print $2}'`
if [ "$NEW_VERSION" != "$CURRENT_VERSION" ]
then
	echo
	echo -e "Successfully upgraded to ${GR}$NEW_VERSION.${NC}"
	success
else
	echo
	echo "Last version $CURRENT_VERSION is same as newly downloaded version $NEW_VERSION. Maybe no newer version is available."
	echo
	echo "Continuing with the newly downloaded binary file. Gitlab-runner binary will be started in next step. Press ENTER to proceed."
	read
	echo
fi


echo "Starting gitlab-runner."
sleep 2
$RUNNER_BINARY start > /dev/null 2>&1
if [ $? -ne 0 ]
then
	error
else
	success
fi


echo "Script ends here."
