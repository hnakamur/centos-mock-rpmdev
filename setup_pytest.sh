#!/bin/sh
set -e

# pytest: NG
yumdownloader --source pytest
rpm -i pytest-*.src.rpm

mv $HOME/rpmbuild/SPECS/pytest.spec $HOME/rpmbuild/SPECS/pytest.spec.orig
sed '
/^Version:/s/[0-9][0-9.]*/2.8.2/
/^Release:/s/\(  *\).*/\11%{?dist}.hnakamur/
/^%changelog/a\
* Mon Nov 16 2015 Hioraki Nakamura <hnakamur@gmail.com> - 2.8.2-1\
- Update to 2.8.2\

' $HOME/rpmbuild/SPECS/pytest.spec.orig > $HOME/rpmbuild/SPECS/pytest.spec

pytest_src_dir=$HOME/rpmbuild/SOURCES/pytest-2.8.2-1.el7.centos.hnakamur.src
mkdir -p $pytest_src_dir
curl -sL -o $pytest_src_dir/pytest-2.8.2.tar.gz http://pypi.python.org/packages/source/p/pytest/pytest-2.8.2.tar.gz

rpmbuild -bs $HOME/rpmbuild/SPECS/pytest.spec
mock --rebuild $HOME/rpmbuild/SRPMS/pytest-2.8.2-1.el7.centos.hnakamur.src.rpm
# pkg_resources.DistributionNotFound: py>=1.4.29
# $ LANG=C yum info python-py | awk '$1=="Version" {print $3}'
# 1.4.14



# python-py: OK
yumdownloader --destdir $HOME/rpmbuild/SRPMS --source python-py
rpm -i $HOME/rpmbuild/SRPMS/python-py-*.src.rpm
mv $HOME/rpmbuild/SPECS/python-py.spec $HOME/rpmbuild/SPECS/python-py.spec.orig
sed '
/^Version:/s/[0-9][0-9.]*/1.4.30/
/^Release:/s/[0-9].*/1%{?dist}.hnakamur/
/^%changelog/a\
* Mon Nov 16 2015 Hioraki Nakamura <hnakamur@gmail.com> - 1.4.30-1\
- Update to 1.4.30.\

' $HOME/rpmbuild/SPECS/python-py.spec.orig > $HOME/rpmbuild/SPECS/python-py.spec

python_py_src_dir=$HOME/rpmbuild/SOURCES/python-py-1.4.30-1.el7.centos.hnakamur.src
mkdir -p $python_py_src_dir
curl -sL -o $python_py_src_dir/py-1.4.30.tar.gz http://pypi.python.org/packages/source/p/py/py-1.4.30.tar.gz

rpmbuild -bs $HOME/rpmbuild/SPECS/python-py.spec
mock --rebuild $HOME/rpmbuild/SRPMS/python-py-1.4.30-1.el7.centos.hnakamur.src.rpm
