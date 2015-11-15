#!/bin/sh -ex

twemproxy_version=0.4.1
twemproxy_release=1

twemproxy_rpm_src_dir=$HOME/rpmbuild/SOURCES/twemproxy-${twemproxy_version}-${twemproxy_release}`rpm --eval '%{dist}'`.hnakamur.src
mkdir -p $twemproxy_rpm_src_dir
curl -sL -o $twemproxy_rpm_src_dir/v${twemproxy_version}.tar.gz https://github.com/twitter/twemproxy/archive/${twemproxy_version}.tar.gz

sudo yum install -y gcc make autoconf automake libtool

tar xf $HOME/rpmbuild/SOURCES/twemproxy-${twemproxy_version}.tar.gz -C $HOME/rpmbuild/SOURCES/
cd $HOME/rpmbuild/SOURCES/twemproxy-${twemproxy_version}
autoreconf -fvi
./configure --prefix=/usr
make
