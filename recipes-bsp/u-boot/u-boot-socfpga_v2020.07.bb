require u-boot-socfpga-common.inc
require recipes-bsp/u-boot/u-boot.inc

LICENSE = "GPLv2+"
LIC_FILES_CHKSUM = "file://Licenses/README;md5=30503fd321432fc713238f582193b78e"

SRCREV = "3adc2a32e299cbd92a6d735c5f0e72adb59a4606"

DEPENDS += "dtc-native bc-native bison-native u-boot-mkimage-native"

do_deploy_append () {
	install -m 644 ${WORKDIR}/build/u-boot-dtb.img ${DEPLOYDIR}/u-boot-dtb.img
}
