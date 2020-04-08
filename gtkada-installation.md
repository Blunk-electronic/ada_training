# How To Install GTKADA ON OpenSuSE Tumbleweed

The installation procedure consists of two steps:
- installation of package Gprbuild
- installation of package Gtkada itself

For both steps two separate bash scripts are provided.

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

**WARNING:**
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
To install Gtkada the shell script [install-gtkada.sh](install-gtkada.sh) is provided.
It does the following:
- Creates in the current working directory a folder "gtkada" where stuff gets unpacked and built.
  This directory should already have been created by the script install-gprbuild.sh (see above).
- clones Gtkada 17.0 from https://github.com/AdaCore/gtkada/archive/gtkada-17.0.tar.gz
- builds Gtkada
- installs gtk3-devel (If this package were missing, configure would abort with message:
  "checking for GTK - version >= 3.14.0... configure: error: old version detected").
- installs Gtkada stuff in /usr/lib/gcc/i586-suse-linux/9/... (for 32bit machines) or
  /usr/lib64/gcc/x86_64-suse-linux/9/... (for 64bit machines)
- Sets the environment variable ADA_PROJECT_PATH in /etc/profile.local .
- If /etc/profile.local does not exist, it will be created.

**WARNING:** 
- YOU LAUNCH THIS SCRIPT ON YOUR OWN RISK !!
- You must be Root !
- Make sure you have a backup of the target directories mentioned above !!

The script must be launched in the same directory where install-gprbuild.sh has been executed (see above).
If the script is launched without any arguments, then it downloads required stuff (see above) in
directory "gtkada" and installs as described. 
To start the installation launch the script in your terminal as follows:

```sh
$ sh install-gtkada.sh
```

If something goes wrong (in case you were not root for example) and you don't 
want to download again then type:

```sh
$ sh install-gtkada.sh no-download
```
NOTE: After the installation you must reboot. See section issues below.

### Uninstalling Gprbuild
If you want to get grid of Gprbuild run this command:

```sh
$ sh install-gprbuild.sh remove
```

CS: Currently the uninstall procedure is not implemented. Nothing will happen.


### Issues
- For unknown reason configure does not detect Open_GL. 
- In case make fails, configure anew with option GL turned off. The relevant lines
  in the install script install-gtkada.sh are commented.
- After the installation you must reboot your machine. 
  The file /etc/profile.local is read only once on boot. Some nice commands in the 
  install script install-gtkada.sh should fix that so that rebooting is no longer required.


## Feedback
Any feedback his highly welcome ! Thanks.

Praise the Lord Jesus Christ.
