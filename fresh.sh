#/bin/bash
################################################################
# bash script for installing and configuring macbook pro 3,1   #
#+ (santa rosa) drivers for any version of ubuntu	       #
# author hlmtre						       #
# thanks to joushou for the smcfancontrol script	       #
# version 0.3						       #
################################################################


if [ "$(id -u)" != "0" ]; then
	echo "Run as root, please." 1>&2
	exit 1
fi

distro=$(lsb_release -cs)
get() {
	wget --no-check-certificate https://hellmitre.homelinux.org/hosted/fresh.tar.gz
	tar xvf fresh.tar.gz
	cd fresh
}
automated() {
echo "Acquiring and adding PGP key..."
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 2B97B7B8

echo "Adding Mactel PPA to sources.list..."
echo "deb http://ppa.launchpad.net/mactel-support/ppa/ubuntu $distro main" >> /etc/apt/sources.list

echo "deb-src http://ppa.launchpad.net/mactel-support/ppa/ubuntu $distro main" >> /etc/apt/sources.list

echo "Updating apt..."
aptitude update

echo "Working..."
rm -f fresh.tar.gz
#---------SETTING ~.conkyrc ----------------------------------------------------	
	cat .conkyrc >> /home/$user/.conkyrc
#------------------------END CONKY .CONKYRC FILE--------------------------------
#---------SETTING ~.bashrc -----------------------------------------------------
	cat .bashrc >> /home/$user/.bashrc
#-------- END .BASHRC SETTING --------------------------------------------------
#--------- REPLACING FIREFOX PROFILE -------------------------------------------
	cp -r .mozilla /home/$user/

# begin installing base desktop/development software
	sudo wget --output-document=/etc/apt/sources.list.d/medibuntu.list http://www.medibuntu.org/sources.list.d/$(lsb_release -cs).list && sudo apt-get --quiet update && sudo apt-get --yes --quiet --allow-unauthenticated install medibuntu-keyring && sudo apt-get --quiet update
	aptitude update && aptitude install -y build-essential ubuntu-restricted-extras libdvdcss2 libdvdread4 vlc compiz compizconfig-settings-manager htop hddtemp netspeed sensors-applet sun-java6-bin sun-java6-jdk sun-java6-jre sun-java6-plugin mpd curl filezilla conky sbackup sonata xchat irssi wine gparted ncmpcpp vim mpdscribble checkgmail scrot elinks cheese mc autoconf libtool emerald tilda compiz-fusion-plugins-extra gimp

aptitude install mbp-nvidia-bl-dkms pommed lm-sensors applesmc-dkms
echo "#!/bin/bash
### BEGIN INIT INFO
# Provides:          loadModules.sh
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Load kernel modules and start
### END INIT INFO

modprobe applesmc;
modprobe coretemp;
pommed;
done
" > /etc/init.d/loadModules.sh
	update-rc.d loadModules.sh defaults

	if [ -f ./smcfancontrol.0.3.2.zip ]; then
		unzip smcfancontrol.0.3.2.zip
		cd smcfancontrol
		./install
	else
		wget --no-check-certificate https://hellmitre.homelinux.org/hosted/smcfancontrol.0.3.2.zip
		unzip smcfancontrol.0.3.2.zip
		cd smcfancontrol
		./install
	fi
}
step() {
echo "Adding Mactel PPA to sources.list..."
echo "deb http://ppa.launchpad.net/mactel-support/ppa/ubuntu $distro main" >> /etc/apt/sources.list

echo "deb-src http://ppa.launchpad.net/mactel-support/ppa/ubuntu $distro main" >> /etc/apt/sources.list

echo "Acquiring and adding PGP key..."
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 2B97B7B8

echo "Updating apt..."
aptitude update

echo "Do you wish to install basic desktop development software?"
echo "This will take some time. Go make a cup of coffee. Still want to do it? y/n"
read choice6
if [ $choice6 = 'y' -o $choice6 = 'Y' -o $choice6 = 'yes' -o $choice6 = 'Yes' ] ; then
echo "Working..."
rm -f fresh.tar.gz
get
#---------SETTING ~.conkyrc ----------------------------------------------------	
	cat .conkyrc >> /home/$user/.conkyrc
#------------------------END CONKY .CONKYRC FILE--------------------------------
#---------SETTING ~.bashrc -----------------------------------------------------
	cat .bashrc >> /home/$user/.bashrc
#-------- END .BASHRC SETTING --------------------------------------------------
#--------- REPLACING FIREFOX PROFILE -------------------------------------------
	cp -r .mozilla /home/$user/

# begin installing base desktop/development software
	sudo wget --output-document=/etc/apt/sources.list.d/medibuntu.list http://www.medibuntu.org/sources.list.d/$(lsb_release -cs).list && sudo apt-get --quiet update && sudo apt-get --yes --quiet --allow-unauthenticated install medibuntu-keyring && sudo apt-get --quiet update
	aptitude update && aptitude install -y build-essential ubuntu-restricted-extras libdvdcss2 libdvdread4 vlc compiz compizconfig-settings-manager htop hddtemp netspeed-sensors-applet sun-java6-bin sun-java6-jdk sun-java6-jre sun-java6-plugin mpd curl filezilla conky sbackup sonata xchat irssi wine gparted ncmpcpp vim mpdscribble checkgmail scrot elinks cheese mc autoconf libtool zsh sshfs
	wget http://www.skype.com/go/getskype-linux-beta-ubuntu-32 && dkpg -i skype-ubuntu-*
else
	echo "Not installing right now."
fi	
echo "Do you want to continue with the script? y/n"
	read choice7
	if [ $choice7 = 'y' -o $choice7 = 'Y' -o $choice7 = 'yes' -o $choice7 = 'Yes' ] ; then
	main_install
else
	echo "Quitting..."
	exit 2;
fi
}
main_install() {
echo "Do you wish to install Macbook Pro 3,1 specific drivers? y/n"
read choice
if [ $choice = 'y' -o $choice = 'Y' -o $choice = 'yes' -o $choice = 'Yes' ] ; then
	aptitude install mbp-nvidia-bl-dkms pommed lm-sensors applesmc-dkms
else 
	echo "Exiting..."
	exit 2;
fi

echo "Do you wish to add the modules that must be loaded at boot to /etc/init.d/? y/n"
read choice2
if [ $choice2 = 'y' -o $choice2 = 'Y' -o $choice2 = 'yes' -o $choice2 = 'Yes' ] ; then
echo "#!/bin/bash
### BEGIN INIT INFO
# Provides:          loadModules.sh
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Load kernel modules and start
### END INIT INFO

modprobe applesmc;
modprobe coretemp;
pommed;
done
" > /etc/init.d/loadModules.sh
	update-rc.d loadModules.sh defaults
else 
	echo "Exiting..."
	exit 2;
fi

echo "Do you wish to install smcfancontrol for more aggressive heat control? y/n"
read choice4
if [ $choice4 = 'y' -o $choice4 = 'Y' -o $choice4 = 'yes' -o $choice4 = 'Yes' ] ; then
	if [ -f ./smcfancontrol.0.3.2.zip ]; then
		unzip smcfancontrol.0.3.2.zip
		cd smcfancontrol
		./install
	else
		wget --no-check-certificate https://hellmitre.homelinux.org/hosted/smcfancontrol.0.3.2.zip
		unzip smcfancontrol.0.3.2.zip
		cd smcfancontrol
		./install
	fi
if [ $choice4 != 'y' || 'Y' || 'yes' || 'Yes' ] ; then
	echo "Do you wish to continue or exit? c/e"
fi
read choice5
if [ $choice5 = 'c' -o $choice5 = 'C' ] ; then
	echo "Reboot is required to make sure everything is installed and configured correctly."
	echo "Do you wish to reboot now? y/n"
	read choice3
	if [ $choice3 = 'y' -o $choice3 = 'Y' -o $choice3 = 'yes' -o $choice3 = 'Yes' ] ; then
		reboot
else
		echo "Remember to reboot later to apply and verify changes."
		exit 2;
	fi
	else
		echo "Exiting..."
		exit 2;
	fi
fi
}
#---------------------END MAIN INSTALL FUNCTION ----------------------------------
LIST="Automated Step-by-step Exit"
PS3="Select a number, please: "
echo "1) Automated installation"
echo "2) Step-by-step walkthrough"
echo "3) Exit"
read opt
	if [ $opt = "1" ]; then
		echo "Proceeding full speed captain!"
		automated
	elif [ $opt = "2" ]; then
		echo "Walking through"
		step
	elif [ $opt = "3" ]; then
		exit 2
	fi
