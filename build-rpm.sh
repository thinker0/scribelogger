#!/bin/sh

sudo yum groupinstall "Development tools"
sudo yum install -y epel-release glib2-devel 
sudo yum install -y thrift-devel fb303-devel
sudo yum install -y vim
sudo yum update -y

APPNAME=scribelogger
VERSION=`awk '/^Version/ {print $2;}' $APPNAME.spec`
RPMBUILDDIR=`rpm --eval "%{_topdir}"`

export CFLAGS="-ggdb $CFLAGS"
rm -rf $RPMBUILDDIR/SOURCES/$APPNAME-$VERSION
cp -pRd . $RPMBUILDDIR/SOURCES/$APPNAME-$VERSION
tar --exclude .git --exclude .vagrant cvfz $RPMBUILDDIR/SOURCES/$APPNAME-$VERSION.tar.gz .
 
BASEDIR=$RPMBUILDDIR/SOURCES/$APPNAME-$VERSION
cd $BASEDIR
./autogen.sh
make -C $RPMBUILDDIR/SOURCES/$APPNAME-$VERSION distclean
cd -
tar -C $RPMBUILDDIR/SOURCES -zcf $RPMBUILDDIR/SOURCES/$APPNAME-$VERSION.tar.gz $APPNAME-$VERSION
rm -rf $BASEDIR
rpmbuild -ba --clean --rmsource $APPNAME.spec
