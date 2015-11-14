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
rpm -i $HOME/rpmbuild/SRPMS/nginx-1.9.6-1.el7.ngx.src.rpm

curl -sL -o $HOME/rpmbuild/SOURCES/nginx-1.9.6-1.el7.ngx.src/ngx_http_consistent_hash-master.tar.gz https://github.com/replay/ngx_http_consistent_hash/archive/master.tar.gz
curl -sL -o $HOME/rpmbuild/SOURCES/nginx-1.9.6-1.el7.ngx.src/nginx_upstream_check_module-master.tar.gz https://github.com/yaoweibin/nginx_upstream_check_module/archive/master.tar.gz
curl -sL -o $HOME/rpmbuild/SOURCES/nginx-1.9.6-1.el7.ngx.src/lua-nginx-module-master.tar.gz https://github.com/openresty/lua-nginx-module/archive/master.tar.gz

sed -i.orig '
/^Release: 1%{?dist}\.ngx/s/\.ngx$/.naruh/
/^Vendor: nginx inc\./s/$/, Hiroaki Nakamura/
/^Source10:/a\
Source11: ngx_http_consistent_hash-master.tar.gz\
Source12: nginx_upstream_check_module-master.tar.gz\
Source13: lua-nginx-module-master.tar.gz
/^BuildRequires: pcre-devel/a\
BuildRequires: luajit-devel
/^a mail proxy server\./a\
This nginx is built with the following modules.\
- ngx_http_consistent_hash\
- nginx_upstream_check_module\
- lua-nginx-module
/^%setup -q/a\
%setup -q -a 11 -a 12 -a 13\
patch -p0 < ./nginx_upstream_check_module-master/check_1.9.2+.patch
/^        --with-ipv6 \\/a\
        --add-module=./ngx_http_consistent_hash-master \\\
        --add-module=./nginx_upstream_check_module-master \\\
        --add-module=./lua-nginx-module-master \\
' $HOME/rpmbuild/SPECS/nginx.spec

mv $HOME/rpmbuild/SOURCES/nginx-1.9.6-1.el7.ngx.src $HOME/rpmbuild/SOURCES/nginx-1.9.6-1.el7.centos.naruh.src
sudo yum-builddep -y $HOME/rpmbuild/SPECS/nginx.spec
rpmbuild -bs $HOME/rpmbuild/SPECS/nginx.spec
mock --rebuild $HOME/rpmbuild/SRPMS/nginx-1.9.6-1.el7.centos.naruh.src.rpm

# $ ls -1 /var/lib/mock/epel-7-x86_64/result/*.rpm
# /var/lib/mock/epel-7-x86_64/result/nginx-1.9.6-1.el7.centos.naruh.src.rpm
# /var/lib/mock/epel-7-x86_64/result/nginx-1.9.6-1.el7.centos.naruh.x86_64.rpm
# /var/lib/mock/epel-7-x86_64/result/nginx-debug-1.9.6-1.el7.centos.naruh.x86_64.rpm
# /var/lib/mock/epel-7-x86_64/result/nginx-debuginfo-1.9.6-1.el7.centos.naruh.x86_64.rpm

