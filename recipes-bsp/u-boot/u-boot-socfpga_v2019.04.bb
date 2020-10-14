require u-boot-socfpga-common.inc
require recipes-bsp/u-boot/u-boot.inc

LICENSE = "GPLv2+"
LIC_FILES_CHKSUM = "file://Licenses/README;md5=30503fd321432fc713238f582193b78e"

SRCREV = "9ad6dad583130e600e835a0d3ff821359b9dc9ab"

DEPENDS += "dtc-native bc-native bison-native u-boot-mkimage-native"

do_git_checkout () {
	cd ${S}
	git checkout rel_socfpga_v2019.04_19.11.02_pr
}

do_patch_prepend() {
    bb.build.exec_func('do_git_checkout', d)
}

do_deploy_append () {
	install -m 644 ${WORKDIR}/build/u-boot-dtb.img ${DEPLOYDIR}/u-boot-dtb.img
}
