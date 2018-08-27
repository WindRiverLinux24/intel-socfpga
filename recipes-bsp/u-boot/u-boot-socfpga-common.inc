HOMEPAGE = "http://www.denx.de/wiki/U-Boot/WebHome"
SECTION = "bootloaders"

LICENSE = "GPLv2+"
LIC_FILES_CHKSUM = "file://Licenses/README;md5=a2c678cfd4a4d97135585cad908541c6"
LIC_FILES_CHKSUM_arm = "file://Licenses/README;md5=c7383a594871c03da76b3707929d2919"

PV = "2017.09"
PV_arm = "2014.10"

SRC_URI = "git://git.denx.de/u-boot.git;branch=master"

S = "${WORKDIR}/git"

RPROVIDES_${PN} += "u-boot"
