FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

DEPENDS_append_intel-socfpga-64 = " coreutils-native u-boot-tools virtual/kernel"
DEPENDS_append_intel-socfpga-64 = " arm-trusted-firmware bash"
DEPENDS_append_intel-socfpga-64 = " s10-u-boot-scr"

SRC_URI_intel-socfpga-64 = "${UBOOT_REPO};protocol=${UBOOT_PROT};nobranch=1"

SRC_URI_append_intel-socfpga-64 = " \
	file://0001-driver-watchdog-reset-watchdog-in-designware_wdt_sto.patch \
	file://0001-driver-watchdog-enable-wdt-command-by-default.patch \
	file://0001-Update-settings-for-ostree.patch \
	file://0001-arch-arm-psci-implement-psci_system_off-interface-fo.patch \
"

inherit deploy

do_compile[deptask] = "do_deploy"

do_compile_append() {
	if ${@bb.utils.contains("MACHINE", "intel-socfpga-64", "true", "false", d)}; then
		for config in ${UBOOT_MACHINE}; do
			if [ "$config" = "socfpga_stratix10_atf_defconfig" ];then
				cp ${DEPLOY_DIR_IMAGE}/bl31.bin ${B}/$config/bl31.bin
				oe_runmake -C ${S} O=${B}/$config u-boot.itb
			fi
		done
	fi
}

do_deploy_append() {
	if ${@bb.utils.contains("MACHINE", "intel-socfpga-64", "true", "false", d)}; then
		for config in ${UBOOT_MACHINE}; do
			install -d ${DEPLOYDIR}/$config
			install -m 744 ${B}/$config/u-boot.img ${DEPLOYDIR}/$config/u-boot.img
			install -m 644 ${B}/$config/u-boot-dtb.img ${DEPLOYDIR}/$config/u-boot-dtb.img
			install -m 644 ${B}/$config/spl/u-boot-spl-dtb.hex ${DEPLOYDIR}/$config/u-boot-spl-dtb.hex
			if [ "$config" = "socfpga_stratix10_atf_defconfig" ];then
				install -m 744 ${B}/$config/u-boot.itb ${DEPLOYDIR}/$config/u-boot.itb
				install -m 744 ${B}/$config/u-boot.itb ${DEPLOYDIR}/u-boot.itb
			fi
			if [ "$config" = "socfpga_stratix10_defconfig" ];then
				install -m 744 ${B}/$config/u-boot.img ${DEPLOYDIR}/u-boot.img
				install -m 644 ${B}/$config/u-boot-dtb.img ${DEPLOYDIR}/u-boot-dtb.img
			fi
		done
	fi
}

COMPATIBLE_MACHINE ?= "(^$)"
COMPATIBLE_MACHINE_intel-socfpga-64 = "intel-socfpga-64"
