#!/bin/sh
set -e

sudo timedatectl set-timezone Asia/Tokyo

# Use only mirror sites in Japan
# http://www.tabimoba.net/entry/20121102/1351858871#.Vka1PN_hDfA
sudo sed -i.orig '$a\
include_only=.jp
' /etc/yum/pluginconf.d/fastestmirror.conf

sudo yum -y install epel-release
sudo yum -y install mock rpmdevtools rpmbuild yum-utils diff patch scl-utils scl-utils-build
sudo mock --init -r epel-7-x86_64
sudo usermod $USER -a -G mock
rpmdev-setuptree
echo '%_sourcedir %{_topdir}/SOURCES/%{name}' >> $HOME/.rpmmacros
