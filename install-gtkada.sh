#! /bin/bash

# ------------------------------------------------------------------------------
# --                                                                          --
# --                           GTKADA iNSTALLER                               --
# --                                                                          --
# --         Copyright (C) 2020 Mario Blunk, Blunk electronic                 --
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
target_dir=/usr/local
download_required=no


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
	wget --no-netrc https://github.com/AdaCore/gtkada/archive/gtkada-17.0.tar.gz
	tar -xf gtkada-17.0.tar.gz
	}

	
	
proc_configure()
	{
	echo "configuring according to machine architecture ..."
	
	# get the architecture:
	cpu=$(lscpu | grep -oP 'Architecture:\s*\K.+')
	
	case "$cpu" in
		i686) 
			echo "32 bit machine"
			./configure --prefix=/usr/lib/gcc/i586-suse-linux/9
			#./configure --prefix=/usr/lib/gcc/i586-suse-linux/8 --without-GL
			;;
			
		x86_64) 
			echo "64 bit machine"
			./configure --prefix=/usr/lib64/gcc/x86_64-suse-linux/9
			#./configure --prefix=/usr/lib/gcc/x86_64-suse-linux/9 --without-GL
			;;
			
		*) echo "ERROR: unkown architecture. Configure failed.";;
	esac
	}

	
# proc_install_warning()
# 	{
# 	echo "installation directory for gtkada: " $target_dir
# 	echo "WARNING: YOU LAUNCH THIS SCRIPT ON YOUR OWN RISK !!"
# 	echo "Make sure you have a backup of" $target_dir "!!"
# 	proc_confimation
# 	}


	
# proc_remove ()
# 	{
# 	echo "removing gprbuild stuff from $target_dir"
# 	proc_confimation
# 	
# 	echo "removing stuff in $target_dir/bin ..."
# 	rm $target_dir/bin/gprbuild
# 	rm $target_dir/bin/gprclean
# 	rm $target_dir/bin/gprconfig
# 	rm $target_dir/bin/gprinstall
# 	rm $target_dir/bin/gprls
# 	rm $target_dir/bin/gprname
# 	
# 	echo "removing stuff in $target_dir/share ..."
# 	rm -rf $target_dir/share/gpr
# 	rm -rf $target_dir/share/gprconfig
# 	
# 	echo "removing stuff in $target_dir/libexec ..."
# 	rm -rf $target_dir/libexec/gprbuild
# 	}

	
	
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
			exit
			;;
			
		*) echo "ERROR: invalid argument:" $1 ;;
	esac
	}
fi


# proc_install_warning

# install gtk3-devel.
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

cd gtkada-gtkada-17.0
proc_configure
#make
#make install


# 
# echo "gprbuild installation complete."
# echo "run command 'gprconfig' to see if gprbuild works."
# echo "Exit gprconfig with CTRL-C."

exit


