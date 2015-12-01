centos-mock-rpmdev
==================

An example of using [Mock - FedoraProject](https://fedoraproject.org/wiki/Mock) on CentOS 7 to build RPMs.
In this example, I rebuild a rpm of [highway](https://github.com/tkengo/highway)

## Usage

Start the virtual machine.

```
vagrant up
```

Log in to the virtual machine.

```
vagrant ssh
```

Build a rpm of highway.

```
./sync/build-highway.sh
```

The build results and logs are created in `/var/lib/mock/epel-7-x86_64/result/`

```
[vagrant@localhost ~]$ LANG=C ls -l /var/lib/mock/epel-7-x86_64/result/
total 948
-rw-rw-r--. 1 mockbuild mock  31672 Dec  2 01:52 build.log
-rw-rw-r--. 1 mockbuild mock 314710 Dec  2 01:52 highway-1.1.0-1.el7.centos.src.rpm
-rw-rw-r--. 1 mockbuild mock 131268 Dec  2 01:52 highway-1.1.0-1.el7.centos.x86_64.rpm
-rw-rw-r--. 1 mockbuild mock 451160 Dec  2 01:52 highway-debuginfo-1.1.0-1.el7.centos.x86_64.rpm
-rw-rw-r--. 1 mockbuild mock  28193 Dec  2 01:52 root.log
-rw-rw-r--. 1 mockbuild mock    713 Dec  2 01:52 state.log
```
