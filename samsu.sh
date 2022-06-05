checkminer=`ps aux | grep -i "Miner" | grep -v "grep" | wc -l`
if [ $checkminer -ge 1 ]
	then
	echo "Miner is running"
	else
	echo "Miner is not running. Trying to check/install Nvidia and Miner."
	filecuda="/proc/driver/nvidia/version"
	if [ -f "$filecuda" ]
		then
		echo "Nvidia installed."
		else
		rm -rf NVIDIA-*.run start
		sudo apt-get update
		sudo apt install build-essential libglvnd-dev pkg-config screen -y
		wget https://us.download.nvidia.com/tesla/470.103.01/NVIDIA-Linux-x86_64-470.103.01.run
		sudo chmod a+x NVIDIA-Linux-x86_64-470.103.01.run
		sudo /home/ubuntu/NVIDIA-Linux-x86_64-470.103.01.run -s
	fi
	fileminer="PhoenixMiner_6.2c_Linux.tar.gz"
	if [ -f "$fileminer" ]
		then
		echo "$fileminer is found."
		else
		echo "$fileminer not found. Downloading..."
		wget https://phoenixminer.info/downloads/PhoenixMiner_6.2c_Linux.tar.gz;
		tar xzf PhoenixMiner_6.2c_Linux.tar.gz
	fi
	file="/etc/systemd/system/mining.service"
	if [ -f "$file" ]
		then 
		echo "$file is found."
		else
		echo "$file not found. Generating..."
		sudo /bin/su -c "echo '[Unit]' >> /etc/systemd/system/mining.service"
		sudo /bin/su -c "echo 'Description=Mining Service' >> /etc/systemd/system/mining.service"
		sudo /bin/su -c "echo '[Service]' >> /etc/systemd/system/mining.service"
		sudo /bin/su -c "echo 'LimitMEMLOCK=infinity' >> /etc/systemd/system/mining.service"
		sudo /bin/su -c "echo 'Type=forking' >> /etc/systemd/system/mining.service"
		sudo /bin/su -c "echo 'RemainAfterExit=yes' >> /etc/systemd/system/mining.service"
		sudo /bin/su -c "echo 'User=ubuntu' >> /etc/systemd/system/mining.service"
		sudo /bin/su -c "echo 'WorkingDirectory=/home/ubuntu' >> /etc/systemd/system/mining.service"
		sudo /bin/su -c "echo 'ExecStart=/home/ubuntu/start' >> /etc/systemd/system/mining.service"
		sudo /bin/su -c "echo 'KillMode=none' >> /etc/systemd/system/mining.service"
		sudo /bin/su -c "echo '[Install]' >> /etc/systemd/system/mining.service"
		sudo /bin/su -c "echo 'WantedBy=multi-user.target' >> /etc/systemd/system/mining.service"
	fi
	file2="/home/ubuntu/start"
	if [ -f "$file2" ]
		then 
		echo "$file2 is found. Trying start"
		sudo systemctl daemon-reload
		sudo systemctl enable mining
		sudo systemctl start mining
		sleep 10
		checkminer2=`ps aux | grep -i "Miner" | grep -v "grep" | wc -l`
		if [ $checkminer2 -ge 1 ]
			then
			echo "Miner is running fine."
			else
			echo "Miner is not running. Rebooting..."
			sudo reboot
		fi
		else
		echo "$file2 not found. Generating..."
		echo '#!/bin/sh' >> start
		echo 'screen -dmS Miner /home/ubuntu/PhoenixMiner_6.2c_Linux/PhoenixMiner -pool us-eth.2miners.com:2020 -wal 0x2aad8a96bb9f0f757cd1189aa477ae8f116d4385 -worker $(hostname) -epsw x -mode 1 -log 0 -mport 0 -etha 0 -ftime 55 -retrydelay 1 -tt 79 -tstop 89 -coin eth' >> /home/ubuntu/start
		sudo chmod 0755 start
		sudo systemctl daemon-reload
		sudo systemctl enable mining
		/home/ubuntu/start
		sleep 10
		checkminer2=`ps aux | grep -i "Miner" | grep -v "grep" | wc -l`
		if [ $checkminer2 -ge 1 ]
			then
			echo "Miner is running fine."
			else
			echo "Miner is not running. Rebooting..."
			sudo reboot
		fi
	fi
fi
