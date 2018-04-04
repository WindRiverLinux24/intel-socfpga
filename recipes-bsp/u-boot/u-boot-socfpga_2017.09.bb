require recipes-bsp/u-boot/u-boot.inc
# This revision is the v2017.09 release
require u-boot-socfpga.inc
SRCREV = "c85cd1fc1331210f1c22adb29d932d4052f79c78"
SRCREV_arm = "2a2102e92e470beec51d8b2dea8323cfc92f92b1"

LICENSE = "GPLv2+"
LIC_FILES_CHKSUM = "file://Licenses/README;md5=a2c678cfd4a4d97135585cad908541c6"
LIC_FILES_CHKSUM_arm = "file://Licenses/README;md5=c7383a594871c03da76b3707929d2919"

PV = "2017.09"
PV_arm = "2014.10"

DEPENDS += "dtc-native"
