#!/bin/bash

# values pattern to look for
core=log4j-core-
api=log4j-api-
api2=log4j-1.2-

# updated jar files
newcore=log4j-core-2.20.0.jar
newapi=log4j-api-2.20.0.jar
newapi2=log4j-1.2-api-2.20.0.jar

# git repo for old jar files
git_backup_repo=/home/ubuntu/backup_config_files/${HOSTNAME}
mkdir "$git_backup_repo"

# download and extract updated jar files
wget https://downloads.apache.org/logging/log4j/2.20.0/apache-log4j-2.20.0-bin.tar.gz
mkdir log4j_binaries
tar -xf apache-log4j-2.20.0-bin.tar.gz -C log4j_binaries
rm apache-log4j-2.20.0-bin.tar.gz

# finding old jar files that needs updating
sudo find / -type f \( -name 'log4j-core-*' -o -name 'log4j-api-*' -o -name 'log4j-1.2-api-*' \) ! -path '*/log4j_binaries/*' ! -path '*/backup_config_files/*' > log4jfiles.txt

# copy list of files that are being changed
cp log4jfiles.txt "$git_backup_repo"

# loops through log4jfiles.txt and swaps old files for updated ones
while read -r line; do
	file=$(basename "$line")
	dir=$(dirname "$line")
	if [[ $line == *"$core"* ]]; then
		sudo cp $line "$git_backup_repo"/"$file"
		sudo rm $line
		sudo cp /home/ubuntu/log4j_binaries/apache-log4j-2.20.0-bin/"$newcore" "$dir"
	elif [[ $line == *"$api"* ]]; then
                sudo cp $line "$git_backup_repo"/"$file"
                sudo rm $line
                sudo cp /home/ubuntu/log4j_binaries/apache-log4j-2.20.0-bin/"$newapi" "$dir"
	elif [[ $line == *"$api2"* ]]; then
                sudo cp $line "$git_backup_repo"/"$file"
                sudo rm $line
                sudo cp /home/ubuntu/log4j_binaries/apache-log4j-2.20.0-bin/"$newapi2" "$dir"
	fi
done < log4jfiles.txt
