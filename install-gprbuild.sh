#! /bin/bash

# ------------------------------------------------------------------------------
# --                                                                          --
# --                           GPRBUILD iNSTALLER                             --
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

install_dir=gtkada_tmp
patch_dir=gprbuild-patch
target_dir=/usr/local
download_required=no

proc_confirmation()
	{
	read -p "Press ENTER to continue. Otherwise press CTRL-C to abort. "
	}

	
proc_make_install_dir()
	{
	if [ -e $install_dir ]; then
		{
		echo "deleting existing" $install_dir
		rm -rf $install_dir
		}
	fi
	
	echo "creating install directory" $install_dir "..."
	mkdir $install_dir
	}

	
proc_dowload_xmlada()
	{
	echo "downloading and unpacking xmlada ..."
	wget --no-netrc https://github.com/AdaCore/xmlada/archive/xmlada-16.1.tar.gz
	# CS: wget --no-netrc https://github.com/AdaCore/xmlada/archive/community-2019.tar.gz
	tar -xf xmlada-16.1.tar.gz
	# CS: tar -xf community-2019.tar.gz
	
	# There is no need to build xmlada.
	}

# CS
# proc_download_gprconfig_kb()
# 	{
# 	echo "downloading gprconfig_kb ..."
# 	git clone https://github.com/AdaCore/gprconfig_kb.git
# 	}

	
proc_download_gprbuild()
	{
	echo "downloading gprbuild ..."
	#git clone https://github.com/AdaCore/gprbuild.git
	wget --no-netrc https://github.com/AdaCore/gprbuild/archive/community-2019.tar.gz
	tar -xf community-2019.tar.gz
	}

	
proc_build_gprbuild()
	{
	echo "building gprbuild ..."
	./bootstrap.sh --with-xmlada=../xmlada-xmlada-16.1 --prefix=./$build_dir
	# CS: ./bootstrap.sh --with-xmlada=../xmlada --prefix=./$build_dir
	}

	
proc_install()
	{
	echo "installing in" $target_dir
	
	# CS: Test whether directory "bin" exists.
	cp $build_dir/bin/* $target_dir/bin/
	
	# CS: Test whether directory "share" exists.
	cp -R $build_dir/share/gpr $target_dir/share/
	cp -R $build_dir/share/gprconfig/ $target_dir/share/
	
	# CS: Test whether directory "libexec" exists.
	cp -R $build_dir/libexec/gprbuild/ $target_dir/libexec/
	}
	
	
proc_patch()
	{
	echo "copying the patch according to machine architecture ..."
	
	# get the architecture:
	cpu=$(lscpu | grep -oP 'Architecture:\s*\K.+')
	
	case "$cpu" in
		i686) 
			echo "32 bit machine"
			cp $patch_dir/compilers_x686.xml $target_dir/share/gprconfig/compilers.xml
			;;
			
		x86_64) 
			echo "64 bit machine"
			cp $patch_dir/compilers_x86_64.xml $target_dir/share/gprconfig/compilers.xml
			;;
			
		*) echo "ERROR: unkown architecture. No patch installed.";;
	esac
	}

	
proc_install_warning()
	{
	echo "installation directory for gprbuild: " $target_dir
	echo "WARNING: YOU LAUNCH THIS SCRIPT ON YOUR OWN RISK !!"
	echo "Make sure you have a backup of" $target_dir "!!"
	proc_confirmation
	}

proc_clean_up ()
	{
	echo "removing $install_dir"
	rm -rf $install_dir
	}
	
proc_remove ()
	{
	echo "removing gprbuild stuff from $target_dir"
	proc_confirmation
	
	echo "removing stuff in $target_dir/bin ..."
	rm $target_dir/bin/gprbuild
	rm $target_dir/bin/gprclean
	rm $target_dir/bin/gprconfig
	rm $target_dir/bin/gprinstall
	rm $target_dir/bin/gprls
	rm $target_dir/bin/gprname
	
	echo "removing stuff in $target_dir/share ..."
	rm -rf $target_dir/share/gpr
	rm -rf $target_dir/share/gprconfig
	
	echo "removing stuff in $target_dir/libexec ..."
	rm -rf $target_dir/libexec/gprbuild
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
			proc_remove
			exit
			;;

		clean-up) 
			proc_clean_up
			exit
			;;
			
		*) echo "ERROR: invalid argument:" $1 ;;
	esac
	}
fi

	
proc_install_warning

if [ "$download_required" = "yes" ]; then
	{
	proc_make_install_dir
	cd $install_dir
	proc_dowload_xmlada
	# CS: proc_download_gprconfig_kb
	proc_download_gprbuild
	}
else
	{
	cd $install_dir	
	}
fi

#cd gprbuild
cd gprbuild-community-2019
build_dir=bootstrap
proc_build_gprbuild
proc_install

# change back to base directory
cd ../../

# CS: if clean up required, call proc_clean_up

# install the patch
proc_patch

echo "gprbuild installation complete."
echo "run command 'gprconfig' to see if gprbuild works."
echo "Exit gprconfig with CTRL-C."

exit


