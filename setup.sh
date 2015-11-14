#!/bin/sh -ex

# Use only mirror sites in Japan
# http://www.tabimoba.net/entry/20121102/1351858871#.Vka1PN_hDfA
sudo sed -i.orig '$a\
include_only=.jp
' /etc/yum/pluginconf.d/fastestmirror.conf

# setup mock
sudo yum update -y
sudo yum install -y epel-release
sudo yum install -y mock rpmdevtools rpmbuild diff patch

rpmdev-setuptree
echo "%_sourcedir %{_topdir}/SOURCES/%{name}-%{version}-%{release}.src" >> $HOME/.rpmmacros

sudo mock --init -r epel-7-x86_64
sudo usermod $USER -a -G mock


# for example build nginx with mock
curl -sL -o $HOME/rpmbuild/SRPMS/nginx-1.9.6-1.el7.ngx.src.rpm http://nginx.org/packages/mainline/centos/7/SRPMS/nginx-1.9.6-1.el7.ngx.src.rpm
mock --rebuild $HOME/rpmbuild/SRPMS/nginx-1.9.6-1.el7.ngx.src.rpm
