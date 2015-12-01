#!/bin/sh
set -eu

sudo -u mockbuild curl -sL -o /home/mockbuild/rpmbuild/SRPMS/highway-1.1.0-1.el7.centos.src.rpm https://copr-be.cloud.fedoraproject.org/results/hnakamur/highway/epel-7-x86_64/00143073-highway/highway-1.1.0-1.el7.centos.src.rpm
sudo -u mockbuild /usr/bin/mock --rebuild /home/mockbuild/rpmbuild/SRPMS/highway-1.1.0-1.el7.centos.src.rpm
