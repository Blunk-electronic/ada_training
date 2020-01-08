# HOWTO INSTALL GTKADA ON OpenSuSE TUMBLEWEED

## Prepare a directory for the installation

- Create a directory 'gtkada' in your non-root home directory:

```sh
$ mkdir gtkada
```

- change into gtkada:

```sh
$ cd gtkada
```

## Install Xmlada

- Download xmlada:

```sh
$ wget https://github.com/AdaCore/xmlada/archive/xmlada-16.1.tar.gz
```

Unpack xmlada:
```sh
$ tar -xf xmlada-16.1.tar.gz
```

There is no need to build xmlada.


## Install Gprbuild

Clone gprbuild:

```sh
$ git clone https://github.com/AdaCore/gprbuild.git
```

Change into directory gprbuild:

```sh
$ cd gprbuild
```

Build gprbuild via command:

```sh
$ ./bootstrap.sh --with-xmlada=../xmlada-xmlada-16.1 --prefix=./bootstrap
```

## Edit file compilers.xml

Edit in bootstrap/share/gprconfig file compilers.xml section "GNAT":
The section starts with:

```xml
   <compiler_description>
    <name>GNAT</name> ...
```
    
Section 'runtimes' should read in its initial form:

```xml
    <runtimes default="default,kernel,native">
       <directory group="default" >\.\./lib/gcc(-lib)?/$TARGET/$gcc_version/adalib/</directory>
       <directory group="default" contents="^rts-">\.\./lib/gcc(-lib)?/$TARGET/$gcc_version/ada_object_path</directory>
       <directory group="2" >\.\./lib/gcc(-lib)?/$TARGET/$gcc_version/rts-(.*)/adalib/</directory>
       <directory group="1" >\.\./$TARGET/lib/gnat/(.*)/adalib/</directory>
    </runtimes>
```
    
### Prepare building on a 64 bit machine

If you want to build on a 64bit machine:
- replace $gcc_version by just 9 (or older gnat version)
- replace \.\./lib by \.\./lib64

Section 'runtimes' should read now:

```xml
    <runtimes default="default,kernel,native">
       <directory group="default" >\.\./lib64/gcc(-lib)?/$TARGET/9/adalib/</directory>
       <directory group="default" contents="^rts-">\.\./lib64/gcc(-lib)?/$TARGET/9/ada_object_path</directory>
       <directory group="2" >\.\./lib64/gcc(-lib)?/$TARGET/9/rts-(.*)/adalib/</directory>
       <directory group="1" >\.\./$TARGET/lib/gnat/(.*)/adalib/</directory>
    </runtimes>
```

### Prepare building on a 32 bit machine

If you want to build on a 32bit machine (they are still around):
- replace $gcc_version by just 9 (or older gnat version)

Section 'runtimes' should read now:

```xml
    <runtimes default="default,kernel,native">
       <directory group="default" >\.\./lib/gcc(-lib)?/$TARGET/9/adalib/</directory>
       <directory group="default" contents="^rts-">\.\./lib/gcc(-lib)?/$TARGET/9/ada_object_path</directory>
       <directory group="2" >\.\./lib/gcc(-lib)?/$TARGET/9/rts-(.*)/adalib/</directory>
       <directory group="1" >\.\./$TARGET/lib/gnat/(.*)/adalib/</directory>
    </runtimes>
```

## Install Gprbuild
- log in as root
- install via command

```sh
$ make install
```

- If that fails do the work manually: 

```sh
$ cp bootstrap/bin/* /usr/local/bin/
$ cp -R bootstrap/share/gpr /usr/local/share/
$ cp -R bootstrap/share/gprconfig/ /usr/local/share/
$ cp -R bootstrap/libexec/gprbuild/ /usr/local/libexec/
```

## Test Gprbuild

type command

```sh
$ gprconfig 
```

It should output this. Most important is the first point in the list. It
indicates, that gprconfig has detected your GNAT compiler properly. No need
to select or save anything here. Just press CTRL-C :

--------------------------------------------------
gprconfig has found the following compilers on your PATH.
Only those matching the target and the selected compilers are displayed.
   1. GNAT for Ada in /usr/bin/ version 8.2 (default runtime)
   2. GCC-ASM for Asm in /usr/bin/ version 8.2.1
   3. GCC-ASM for Asm2 in /usr/bin/ version 8.2.1
   4. GCC-ASM for Asm_Cpp in /usr/bin/ version 8.2.1
   5. GCC for C in /usr/bin/ version 8.2.1
   6. G++ for C++ in /usr/bin/ version 8.2.1
Select or unselect the following compiler (or "s" to save): 


## Install Gtkada

Make sure package gtk3-devel is installed.

Login as non-root user:

Download https://github.com/AdaCore/gtkada/archive/gtkada-17.0.tar.gz in directory
gtkada, unpack and change into gtkada-gtkada-17.0.

Change back to directory gtkada:
```sh
$ cd ..
```

Download gtkada (currently version 17.0)

```sh
$ wget https://github.com/AdaCore/gtkada/archive/gtkada-17.0.tar.gz
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
ADA_PROJECT_PATH=/usr/lib64/gcc/x86_64-suse-linux/9/lib/gnat/
export ADA_PROJECT_PATH

## 32 bit machine
ADA_PROJECT_PATH=/usr/lib/gcc/i586-suse-linux/9/lib/gnat/
export ADA_PROJECT_PATH

Reboot your machine.

Now you should be able to compile your ada gtk projects.

Any feedback his highly welcome ! Thanks.
