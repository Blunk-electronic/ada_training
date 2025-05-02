#! /bin/bash

# ------------------------------------------------------------------------------
# --                                                                          --
# --                           GPRBUILD iNSTALLER                             --
# --                                                                          --
# --         Copyright (C) 2025 Mario Blunk, Blunk electronic                 --
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
# --   or visit <http://www.blunk-electronic.de> for more contact information
# --
# --   history of changes:
# --


# exit this script on error:
set -e

release=25.0.0
release_prefix=v$release

install_dir=gprbuild_tmp
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
	wget --no-netrc https://github.com/AdaCore/xmlada/archive/refs/tags/$release_prefix.tar.gz
	tar -xf $release_prefix.tar.gz
	rm $release_prefix.tar.gz
	# There is no need to build xmlada.
	}


proc_download_gprconfig_kb()
	{
	echo "downloading gprconfig_kb ..."
	wget --no-netrc https://github.com/AdaCore/gprconfig_kb/archive/refs/tags/$release_prefix.tar.gz
	tar -xf $release_prefix.tar.gz
	rm $release_prefix.tar.gz
	}

	
proc_download_gprbuild()
	{
	echo "downloading gprbuild ..."
	wget --no-netrc https://github.com/AdaCore/gprbuild/archive/refs/tags/$release_prefix.tar.gz
	tar -xf $release_prefix.tar.gz
	rm $release_prefix.tar.gz
	}

	
proc_bootstrap_gprbuild()
	{
	echo "bootstrapping gprbuild ..."
	cd gprbuild-$release
	./bootstrap.sh --with-xmlada=../xmlada-$release --with-kb=../gprconfig_kb-$release --prefix=./bootstrap
	export PATH=$PATH:$PWD/bootstrap/bin/
	cd ..
	}


proc_build_xmlada()
	{
	echo "building xmlada ..."
	cd xmlada-$release
	./configure --prefix=$PWD/install
	make all
	make install
	export GPR_PROJECT_PATH=$PWD/install/share/gpr/
	cd ..
	}


proc_build_gprbuild()
	{
	echo "building gprbuild ..."
	cd gprbuild-$release
	make all
	make install
	cd ..
	}



proc_install_warning()
	{
	echo "WARNING: YOU LAUNCH THIS SCRIPT ON YOUR OWN RISK !!"
	echo "Make sure you have a backup of your system !!"
	proc_confirmation
	}

	
proc_clean_up ()
	{
	echo "removing $install_dir"
	rm -rf $install_dir
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
			
# 		remove)
# 			proc_remove
# 			exit
# 			;;

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
	proc_download_gprconfig_kb
 	proc_download_gprbuild
	}
else
	{
	cd $install_dir	
	}
fi

proc_bootstrap_gprbuild
proc_build_xmlada
proc_build_gprbuild

# change back to base directory
cd ../../


echo "gprbuild installation complete."
echo "run command 'gprconfig' to see if gprbuild works."
echo "Exit gprconfig with CTRL-C."

exit


