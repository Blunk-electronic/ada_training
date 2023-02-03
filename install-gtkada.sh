#! /bin/bash

# ------------------------------------------------------------------------------
# --                                                                          --
# --                           GTKADA INSTALLER                               --
# --                                                                          --
# --         Copyright (C) 2023 Mario Blunk, Blunk electronic                 --
# --                                                                          --
# --    This program is free software: you can redistribute it and/or modify  --
# --    it under the terms of the GNU General Public License as published by  --
# --    the Free Software Foundation, either version 3 of the License, or     --
# --    (at your option) any later version.                                   --
# --                                                                          --
# --    This program is distributed in the hope that it will be useful,       --
# --    but WITHOUT ANY WARRANTY; without even the implied warranty of        --
# --    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         --
# --    GNU General Public License for more details.                          --
# --                                                                          --
# --    You should have received a copy of the GNU General Public License     --
# --    along with this program.  If not, see <http://www.gnu.org/licenses/>. --
# ------------------------------------------------------------------------------
# 
# --   For correct displaying set tab width in your editor to 4.
# 
# --   The two letters "CS" indicate a "construction site" where things are not
# --   finished yet or intended for the future.
# 
# --   Please send your questions and comments to:
# --
# --   info@blunk-electronic.de
# --   or visit <http://www.blunk-electronic.de> for more contact data
# --
# --   history of changes:
# --


#set -e

install_dir=gtkada
download_required=no

# get the architecture:
cpu=$(lscpu | grep -oP 'Architecture:\s*\K.+')
	
# get the gcc version:
gcc_version=$(gcc -dumpversion)

target_dir_32bit=/usr/lib/gcc/i586-suse-linux/$gcc_version
target_dir_64bit=/usr/lib64/gcc/x86_64-suse-linux/$gcc_version

profile_file=/etc/profile.local


proc_confimation()
	{
	read -p "Press ENTER to continue. Otherwise press CTRL-C to abort. "
	}

	
proc_make_install_dir()
	{
	if [ -e $install_dir ]; then
		{
		echo "install directory" $install_dir "already exists"
		}
	else
		{
		echo "creating install directory" $install_dir "..."
		mkdir $install_dir
		}
	fi
	}


proc_download_gtkada()
	{
	echo "downloading and unpacking gtkada ..."
	#wget --no-netrc https://github.com/AdaCore/gtkada/archive/gtkada-17.0.tar.gz
	wget --no-netrc https://github.com/AdaCore/gtkada/archive/refs/tags/v23.0.0.tar.gz
	tar -xf v23.0.0.tar.gz
	
# 	echo "cloning gtkada ..."
# 	git clone https://github.com/AdaCore/gtkada.git
	}

	
	
proc_configure()
	{
	echo "configuring according to machine architecture ..."
	
	case "$cpu" in
		i686) 
			echo "32 bit machine"
			./configure --prefix=$target_dir_32bit
# 			./configure --prefix=$target_dir_32bit --without-GL
			;;
			
		x86_64) 
			echo "64 bit machine"
			./configure --prefix=$target_dir_64bit
# 			./configure --prefix=$target_dir_64bit --without-GL
			;;
			
		*)
			echo "ERROR: unkown architecture. Configure failed."
			exit 1
			;;
	esac
	}

	
proc_install_warning()
	{
	echo "gtkada will be installed in target directory:"
	case "$cpu" in
		i686) 
			echo $target_dir_32bit
			;;
			
		x86_64) 
			echo $target_dir_64bit
			;;
			
		*) 
			echo "ERROR: unkown architecture. Configure failed."
			exit 1
			;;
	esac

	echo "WARNING: YOU LAUNCH THIS SCRIPT ON YOUR OWN RISK !!"
 	echo "Make sure you have a backup of the target directory !!"
	proc_confimation
	}


proc_setup_profile()
	{
	echo "setting up" $profile_file "..."

	ada_prj="export ADA_PROJECT_PATH="
	gnat_dir=/lib/gnat/
	
	# If $profile_file exists, append the ada project path to the file.
	# If $profile_file not exists, create it and write the ada project path in it:
	
	if [ -e $profile_file ]; then
		{
		# profile file exists -> append
		case "$cpu" in
			i686) 
 				echo $ada_prj$target_dir_32bit$gnat_dir >> $profile_file
 				#export $ada_prj$target_dir_32bit$gnat_dir
				;;
				
			x86_64) 
 				echo $ada_prj$target_dir_64bit$gnat_dir >> $profile_file
 				#export $ada_prj$target_dir_64bit$gnat_dir
 				;;
				
			*) 
				echo "ERROR: unkown architecture. Configure failed."
				exit 1
				;;
		esac
		}
	else
		{
		# profile file does not exist -> create it
		case "$cpu" in
			i686) 
 				echo $ada_prj$target_dir_32bit$gnat_dir > $profile_file
				export $ada_prj$target_dir_32bit$gnat_dir
				;;
				
			x86_64) 
 				echo $ada_prj$target_dir_64bit$gnat_dir > $profile_file
				export $ada_prj$target_dir_64bit$gnat_dir
				;;
				
			*) 
				echo "ERROR: unkown architecture. Configure failed."
				exit 1
				;;
		esac
		}
	fi
	}
	
	
############ MAIN BEGIN #####################################################################


# Test arguments. If argument is "no-download", then no downloading will take place.
if [ $# -eq 0 ]; then
	{
    download_required=yes
    }
else
	{
	case "$1" in
		no-download) 
			download_required=no
			;;
			
		remove) 
#			proc_remove CS
			exit 1
			;;
			
		*) 
			echo "ERROR: invalid argument:" $1
			exit 1;;
	esac
	}
fi


proc_install_warning

# Install gtk3-devel.
# If this package is missing, configure will abort with message:
# "checking for GTK - version >= 3.14.0... configure: error: old version detected".
# If gtk3-devel is alread installed, nothing happens:
zypper install gtk3-devel



if [ "$download_required" = "yes" ]; then
	{
	proc_make_install_dir
	cd $install_dir
	proc_download_gtkada
	}
else
	{
	cd $install_dir	
	}
fi

cd gtkada-23.0.0
proc_configure

make
make install

proc_setup_profile

echo "gtkada installation complete."
exit
