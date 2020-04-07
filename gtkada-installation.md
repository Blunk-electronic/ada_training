# How To Install GTKADA ON OpenSuSE Tumbleweed

## Install Gprbuild
To install Gprbuild the shell script [install-gprbuild.sh](install-gprbuild.sh) is provided.
It does the following:
- creates in the current working directory a folder "gtkada" where stuff gets unpacked and built
- downloads Xmlada 16.1 from https://github.com/AdaCore/xmlada/archive/xmlada-16.1.tar.gz
- unpacks Xmlada
- clones Gprbuild from https://github.com/AdaCore/gprbuild.git
- builds Gprbuild
- installs Gprbuild stuff in /usr/local/bin, /usr/local/share and /usr/local/libexec
- Overwrites in /usr/local/share/gprconfig the file compilers.xml with a patched version.

WARNING: 
- YOU LAUNCH THIS SCRIPT ON YOUR OWN RISK !!
- You must be Root !
- Make sure you have a backup of /usr/local !!

If the script is launched without any arguments, then it downloads required stuff (see above) in
directory "gtkada" and installs as described. 
To start the installation launch the script in your terminal as follows:

```sh
$ sh install-gprbuild.sh
```

If something goes wrong (in case you were not root for example) and you don't 
want to download again then type:

```sh
$ sh install-gprbuild.sh no-download
```

### Uninstalling Gprbuild
If you want to get grid of Gprbuild run this command:
```sh
$ sh install-gprbuild.sh remove
```


## Install Gtkada

Make sure package gtk3-devel is installed.
If this package is missing, configure will abort with message:
"checking for GTK - version >= 3.14.0... configure: error: old version detected".

Login as non-root user:

Change into to directory 'gtkada' (It has been created by the script install-gprbuild.sh (see above):

```sh
$ cd gtkada
```


Download gtkada (currently version 17.0)

```sh
$ wget --no-netrc https://github.com/AdaCore/gtkada/archive/gtkada-17.0.tar.gz
```

Unpack:

```sh
$ tar -xf gtkada-17.0.tar.gz
```

Change into directory gtkada-17.0

```sh
$ cd gtkada-17.0
```


### Configure on a 32 bit machine
```sh
$ ./configure --prefix=/usr/lib/gcc/i586-suse-linux/9
```

### Configure on a 64 bit machine
```sh
$ ./configure --prefix=/usr/lib64/gcc/x86_64-suse-linux/9
```

### Building
```sh
$ make
```

In case make fails, configure anew with option GL turned off like
```sh
$ ./configure --prefix=/usr/lib/gcc/i586-suse-linux/8 --without-GL
```

then run make again.

Login as root and do the final installation step:

```sh
$ make install
```


## Set the Ada project path

Make sure the environment variable ADA_PROJECT_PATH is set so that
gtkada.gpr can be found. For example do this (as root) in /etc/profile.local via these
lines:

### 64 bit machine
```sh
ADA_PROJECT_PATH=/usr/lib64/gcc/x86_64-suse-linux/9/lib/gnat/
export ADA_PROJECT_PATH
```

### 32 bit machine
```sh
ADA_PROJECT_PATH=/usr/lib/gcc/i586-suse-linux/9/lib/gnat/
export ADA_PROJECT_PATH
```

Reboot your machine.

Now you should be able to compile your ada gtk projects.

Any feedback his highly welcome ! Thanks.

Praise the Lord Jesus Christ.
