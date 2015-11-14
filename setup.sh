#!/bin/sh -ex

# RPMs cache config
maximum_object_size='5 GB'
cache_dir_size_mb=10000 # 10GB

# Use only mirror sites in Japan
# http://www.tabimoba.net/entry/20121102/1351858871#.Vka1PN_hDfA
sudo sed -i.orig '$a\
include_only=.jp
' /etc/yum/pluginconf.d/fastestmirror.conf

# setup cache for RPMs
# http://serverascode.com/2014/03/29/squid-cache-yum.html
# http://ma.ttwagner.com/lazy-distro-mirrors-with-squid/
# http://dummdida.tumblr.com/post/91342527085/caching-large-objects-and-repos-with-squid-easy
# NOTE:
#   Use the following command to check the squid config file syntax is valid
#   sudo squid -k check
sudo yum install -y squid
# We overwrite /etc/squid/squid.conf since the original file exists at /etc/squid/squid.conf.default
sed '
/^#cache_dir/a\
# Note: maximum_object_size must be above cache_dir\
maximum_object_size '"$maximum_object_size"'\
cache_dir ufs /var/spool/squid '$cache_dir_size_mb' 16 256\
# Use the LFUDA cache eviction policy -- Least Frequently Used, with\
#  Dynamic Aging. http://www.squid-cache.org/Doc/config/cache_replacement_policy/\
# It'\''s more important to me to keep bigger files in cache than to keep\
# more, smaller files -- I am optimizing for bandwidth savings, not latency.\
cache_replacement_policy heap LFUDA
/^refresh_pattern \^ftp:/i\
\
# The top two are new lines, and probably aren'\''t everything you would ever\
# want to cache -- I don'\''t account for VM images, .deb files, etc.\
# They'\''re cached for 129600 minutes, which is 90 days.\
# refresh-ims and override-expire are described in the configuration here:\
#  http://www.squid-cache.org/Doc/config/refresh_pattern/\
# but basically, refresh-ims makes squid check with the backend server\
# when someone does a conditional get, to be cautious.\
# override-expire lets us override the specified expiry time. (This is\
#  illegal per the RFC, but works for our specific purposes.)\
# You will probably want to tune this part.\
refresh_pattern -i \\.rpm$ 129600 100% 129600 refresh-ims override-expire\
refresh_pattern -i \\.iso$ 129600 100% 129600 refresh-ims override-expire\

' /etc/squid/squid.conf.default | sudo sh -c 'cat > /etc/squid/squid.conf'

sudo systemctl start squid
sudo systemctl enable squid

# set up yum proxy
sudo sed -i.orig '/^distroverpkg=/a\
proxy=http://127.0.0.1:3128
' /etc/yum.conf
sudo sed -i.orig '/^syslog_device=/a\
proxy=http://127.0.0.1:3128
' /etc/mock/epel-7-x86_64.cfg

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
