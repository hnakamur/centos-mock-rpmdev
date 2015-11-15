#!/bin/sh
set -e

sudo yum install -y git tito

# # python marshallow
# sudo yum install -y python-virtualenv python-pip
# 
# virtualenv $HOME/venv
# . $HOME/venv/bin/activate
# pip install marshmallow

git clone https://github.com/marshmallow-code/marshmallow
cd marshmallow
git checkout 2.2.1
python setup.py bdist_rpm --requires=python-dateutil,python-simplejson || :
# $ echo $?
# 1

marshmallow_src_dir=$HOME/rpmbuild/SOURCES/python-marshmallow-2.2.1-1.hnakamur.src
mkdir -p $marshmallow_src_dir
curl -sL -o $marshmallow_src_dir/python-marshmallow-2.2.1.tar.gz https://github.com/marshmallow-code/marshmallow/archive/2.2.1.tar.gz
tar xf $marshmallow_src_dir/python-marshmallow-2.2.1.tar.gz -C $HOME/rpmbuild/SOURCES/
(cd $HOME/rpmbuild/SOURCES/marshmallow-2.2.1 && python setup.py bdist_rpm --requires=python-dateutil,python-simplejson || :)

sed '
/^Name:/s/%{name}/python-&/
/^Release:/s/%{release}/&.hnakamur/
/^License:/s/ .*/ MIT/
/^Permission is hereby granted, free of charge, to any person obtaining a copy/,/THE SOFTWARE\./d
/^%setup /s/.*/%setup -qn marshmallow-%{unmangled_version}/
' $HOME/rpmbuild/SOURCES/marshmallow-2.2.1/build/bdist.linux-x86_64/rpm/SPECS/marshmallow.spec > $HOME/rpmbuild/SPECS/python-marshmallow.spec
rpmbuild -ba $HOME/rpmbuild/SPECS/python-marshmallow.spec
sudo yum install -y $HOME/rpmbuild/RPMS/noarch/python-marshmallow-2.2.1-1.hnakamur.noarch.rpm


git clone https://git.fedorahosted.org/git/copr.git $HOME/rpmbuild/SOURCES/copr

# python-copr
yumdownloader --destdir $HOME/rpmbuild/SRPMS --source python-copr
rpm -i $HOME/rpmbuild/SRPMS/python-copr-1.57-1.el7.src.rpm
(cd $HOME/rpmbuild/SOURCES/copr/python && tito build --tgz)
mkdir -p $HOME/rpmbuild/SOURCES/python-copr-1.61-1.el7.centos.hnakamur.src
mv /tmp/tito/python-copr-1.61.tar.gz $HOME/rpmbuild/SOURCES/python-copr-1.61-1.el7.centos.hnakamur.src/

mv $HOME/rpmbuild/SPECS/python-copr.spec $HOME/rpmbuild/SPECS/python-copr.spec.orig
sed '
/^Version:/s/\(  *\).*/\11.61/
/^Release:/s/$/.hnakamur/
/^Release:/a\
Vendor:     Hiroaki Nakamura
/^BuildRequires: python-requests/a\
BuildRequires: python-requests-toolbelt
/^%changelog/a\
* Sun Nov 15 2015 Hiroaki Nakamura <hnakamur@gmail.com> 1.61-1\
- Use python-copr version 1.61-1\

' $HOME/rpmbuild/SPECS/python-copr.spec.orig > $HOME/rpmbuild/SPECS/python-copr.spec
rpmbuild -bs $HOME/rpmbuild/SPECS/python-copr.spec
mock --rebuild $HOME/rpmbuild/SRPMS/python-copr-1.61-1.el7.centos.hnakamur.src.rpm




# copr-cli
yumdownloader --destdir $HOME/rpmbuild/SRPMS --source copr-cli
rpm -i $HOME/rpmbuild/SRPMS/copr-cli-1.45-1.el7.src.rpm

(cd $HOME/rpmbuild/SOURCES/copr/cli && tito build --tgz)
mkdir -p $HOME/rpmbuild/SOURCES/copr-cli-1.46-1.el7.centos.hnakamur.src
mv /tmp/tito/copr-cli-1.46.tar.gz $HOME/rpmbuild/SOURCES/copr-cli-1.46-1.el7.centos.hnakamur.src/

sed -i.orig '
/^Version:/s/1\.45/1.46/
/^Release:/s/$/.hnakamur/
/^Release:/a\
Vendor:     Hiroaki Nakamura
/^%changelog/a\
* Sun Nov 15 2015 Hiroaki Nakamura <hnakamur@gmail.com> 1.46-1\
- Use copr-cli version 1.46-1\

' $HOME/rpmbuild/SPECS/copr-cli.spec
rpmbuild -bs $HOME/rpmbuild/SPECS/copr-cli.spec
mock --rebuild $HOME/rpmbuild/SRPMS/copr-cli-1.46-1.el7.centos.hnakamur.src.rpm
sudo yum install -y /var/lib/mock/epel-7-x86_64/result/copr-cli-1.46-1.el7.centos.hnakamur.noarch.rpm
