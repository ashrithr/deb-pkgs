#!/usr/bin/env bash
VERSION=0.7.2
REVISION=1
BUILD_DIR="kafka_$VERSION-$REVISION"
TARFILE="kafka-$VERSION-incubating-src.tgz"
URL="http://mirror.symnds.com/software/Apache/incubator/kafka/kafka-$VERSION-incubating/$TARFILE"
KAFKA_DIR="$BUILD_DIR/opt/kafka"

# BUILD_DIR (kafka_0.7.2-1)
#   KAFKA_DIR (opt/kafka)
#     * all files after building
#   etc/default
#     kafka
#   etc/init
#     kafka-server
#   DEBIAN
#     changelog
#     control

cd /tmp
# Create req dir's
[ ! -f "${BUILD_DIR}" ] && mkdir $BUILD_DIR
[ ! -f "${TARFILE}" ] && wget $URL -O $TARFILE
[ ! -f "${KAFKA_DIR}" ] && mkdir -p ${KAFKA_DIR}
# Clean up if already exists
[ -f "${KAFKA_DIR}" ] && rm -rf ${KAFKA_DIR}
[ -f "${BUILD_DIR}.deb" ] && rm "${BUILD_DIR}.deb"
tar xzf $TARFILE --strip 1 -C $KAFKA_DIR
cd $KAFKA_DIR
java -version 2>/dev/null || apt-get install -y openjdk-6-jdk
./sbt update
./sbt package
[ $? -ne 0 ] && { echo "Failed building package"; exit 1; }
cd /tmp/$BUILD_DIR
mkdir DEBIAN
# Get the control files
curl https://raw.github.com/ashrithr/deb-pkgs/master/kafka-0.7/DEBIAN/control -o DEBIAN/control
curl https://raw.github.com/ashrithr/deb-pkgs/master/kafka-0.7/DEBIAN/changelog -o DEBIAN/changelog
curl https://raw.github.com/ashrithr/deb-pkgs/master/kafka-0.7/DEBIAN/preinst -o DEBIAN/preinst
chmod 755 DEBIAN/preinst
mkdir -p etc/{init,default}
# Get Maintiner Scrits
curl https://raw.github.com/ashrithr/deb-pkgs/master/kafka-0.7/etc/default/kafka -o etc/default/kafka
curl https://raw.github.com/ashrithr/deb-pkgs/master/kafka-0.7/etc/init/kafka-server -o etc/init/kafka-server
dpkg-deb --build /tmp/$BUILD_DIR