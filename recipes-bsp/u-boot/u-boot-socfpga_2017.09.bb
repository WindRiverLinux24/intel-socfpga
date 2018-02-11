require recipes-bsp/u-boot/u-boot.inc
# This revision is the v2017.09 release
require u-boot-socfpga.inc
SRCREV = "4a634e3b1583a267ca39838f68ad26ed080012d0"

LICENSE = "GPLv2+"
LIC_FILES_CHKSUM = "file://Licenses/README;md5=a2c678cfd4a4d97135585cad908541c6"

PV = "2017.09"

DEPENDS += "dtc-native"
