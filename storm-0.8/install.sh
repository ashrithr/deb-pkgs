#!/usr/bin/env bash
set -x
VERSION=0.8.2
REVISION=1
BUILD_DIR="storm_$VERSION-$REVISION"
TARFILE="storm-$VERSION.zip"
URL="https://dl.dropbox.com/u/133901206/$TARFILE"
STORM_DIR="$BUILD_DIR/opt/storm"

# BUILD_DIR (storm_0.8.2-1)
#   STORM_DIR (opt/storm)
#     * all files after building
#   etc/default
#     storm
#   etc/init
#     storm-nimbus.conf
#     storm-supervisor.conf
#     storm-ui.conf
#   DEBIAN
#     changelog
#     control
#     postinst
#     preinst

cd /tmp
# Create req dir's
[ ! -f "${BUILD_DIR}" ] && mkdir $BUILD_DIR
[ ! -f "${TARFILE}" ] && wget $URL -O $TARFILE
[ ! -f "${STORM_DIR}" ] && mkdir -p ${STORM_DIR}
# Clean up if already exists
[ -f "${STORM_DIR}" ] && rm -rf ${STORM_DIR}
[ -f "${BUILD_DIR}.deb" ] && rm "${BUILD_DIR}.deb"
apt-get install unzip
unzip $TARFILE
cp -r storm-${VERSION}/* ${STORM_DIR}
cd $STORM_DIR
cd /tmp/$BUILD_DIR
mkdir DEBIAN
# Get the control files
curl https://raw.github.com/ashrithr/deb-pkgs/master/storm-0.8/DEBIAN/control -o DEBIAN/control
curl https://raw.github.com/ashrithr/deb-pkgs/master/storm-0.8/DEBIAN/changelog -o DEBIAN/changelog
curl https://raw.github.com/ashrithr/deb-pkgs/master/storm-0.8/DEBIAN/preinst -o DEBIAN/preinst
curl https://raw.github.com/ashrithr/deb-pkgs/master/storm-0.8/DEBIAN/postinst -o DEBIAN/postinst
chmod 755 DEBIAN/preinst
chmod 755 DEBIAN/postinst
mkdir -p etc/{init,default}
# Get Maintainer Scrits
curl https://raw.github.com/ashrithr/deb-pkgs/master/storm-0.8/etc/default/storm -o etc/default/storm
curl https://raw.github.com/ashrithr/deb-pkgs/master/storm-0.8/etc/init/storm-nimbus.conf -o etc/init/storm-nimbus.conf
curl https://raw.github.com/ashrithr/deb-pkgs/master/storm-0.8/etc/init/storm-supervisor.conf -o etc/init/storm-supervisor.conf
curl https://raw.github.com/ashrithr/deb-pkgs/master/storm-0.8/etc/init/storm-ui.conf -o etc/init/storm-ui.conf
dpkg-deb --build /tmp/$BUILD_DIR