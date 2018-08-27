require u-boot-socfpga-common.inc
require recipes-bsp/u-boot/u-boot.inc
# This revision is the v2017.09 release
SRCREV = "c6316edf709a49d52f2c613eda6f15994ce7cd31"
SRCREV_arm = "2a2102e92e470beec51d8b2dea8323cfc92f92b1"

UBOOT_REPO ?= "git://github.com/altera-opensource/u-boot-socfpga.git"
UBOOT_BRANCH ?= "socfpga_v${PV}"
UBOOT_BRANCH_arm = "socfpga_v${PV}_arria10_bringup"
UBOOT_PROT ?= "http"

SRC_URI = "${UBOOT_REPO};protocol=${UBOOT_PROT};branch=${UBOOT_BRANCH}"

DEPENDS += "dtc-native"

do_deploy_append_aarch64 () {
	install -m 644 ${WORKDIR}/build/u-boot-dtb.img ${DEPLOYDIR}/u-boot-dtb.img
}

do_deploy_append_arm () {
	install -m 644 ${WORKDIR}/build/u-boot.img ${DEPLOYDIR}/u-boot-dtb.img
}
addtask deploy before do_build after do_compile
