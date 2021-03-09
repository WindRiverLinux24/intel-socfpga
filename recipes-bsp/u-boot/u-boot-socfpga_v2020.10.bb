require u-boot-socfpga-common.inc

DEPENDS += "s10-u-boot-scr"

UBOOT_VERSION = "v2020.10"

SRCREV = "ced41867be2d09f4a8af2cc33f45c8ee7a67c6fe"

do_deploy_append () {
	install -m 644 ${WORKDIR}/build//socfpga_stratix10_defconfig/u-boot-dtb.img ${DEPLOYDIR}/u-boot-dtb.img
}
