#! /bin/bash

set -e

install_dir=gtkada
target_dir=/usr/local
download_required=no

echo "installation directory for gprbuild: " $target_dir
echo "WARNING: YOU LAUNCH THIS SCRIPT ON YOUR OWN RISK !!"
echo "Make sure you have a backup of" $target_dir "!!"
read -p "Press ENTER to continue. Otherwise press CTRL-C to abort. "

# Test argument. If argument is "no-download", then no downloading will take place.
if [ $# -eq 0 ]; then
	{
    download_required=yes
    }
else
	{
	if [ "$1" = "no-download" ]; then
		{
		download_required=no
		}
	fi
	}
fi

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
	# download and unpack xmlada
	wget --no-netrc https://github.com/AdaCore/xmlada/archive/xmlada-16.1.tar.gz
	tar -xf xmlada-16.1.tar.gz
	# There is no need to build xmlada.
	}

proc_download_gprbuild()
	{
	# download gprbuild
	git clone https://github.com/AdaCore/gprbuild.git
	}

build_dir=bootstrap

proc_build_gprbuild()
	{
	./bootstrap.sh --with-xmlada=../xmlada-xmlada-16.1 --prefix=./$build_dir
	}

proc_install()
	{
	echo "installing in" $target_dir
	cp $build_dir/bin/* $target_dir/bin/
	cp -R $build_dir/share/gpr $target_dir/share/
	cp -R $build_dir/share/gprconfig/ $target_dir/share/
	cp -R $build_dir/libexec/gprbuild/ $target_dir/libexec/
	}
	

if [ "$download_required" = "yes" ]; then
	{
	proc_make_install_dir
	cd $install_dir
	proc_dowload_xmlada
	proc_download_gprbuild
	}
else
	{
	cd $install_dir	
	}
fi

cd gprbuild
proc_build_gprbuild
proc_install

exit


