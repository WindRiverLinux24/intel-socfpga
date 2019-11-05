require u-boot-socfpga-common.inc
require recipes-bsp/u-boot/u-boot.inc

LICENSE = "GPLv2+"
LIC_FILES_CHKSUM = "file://Licenses/README;md5=30503fd321432fc713238f582193b78e"

SRCREV = "8c4cd804d6d77fbc4d7201d19755b6e89d43ae65"

DEPENDS += "dtc-native bc-native bison-native u-boot-mkimage-native"

do_deploy_append () {
	install -m 644 ${WORKDIR}/build/u-boot-dtb.img ${DEPLOYDIR}/u-boot-dtb.img
}
