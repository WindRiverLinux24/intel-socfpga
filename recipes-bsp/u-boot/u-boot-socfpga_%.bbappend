FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

DEPENDS:append:intel-socfpga-64 = " coreutils-native u-boot-tools virtual/kernel"
DEPENDS:append:intel-socfpga-64 = " arm-trusted-firmware bash"
DEPENDS:append:intel-socfpga-64 = " s10-u-boot-scr"

SRC_URI:append:intel-socfpga-64 = " \
	file://0001-driver-watchdog-enable-wdt-command-by-default.patch \
	file://0001-Update-settings-for-ostree.patch \
	file://0001-configs-socfpga-create-MMC-specific-defconfig-for-st.patch \
	file://0001-configs-socfpga-create-MMC-specific-defconfig-for-ag.patch \
	file://0001-arm-dts-socfpga-set-specific-atf-file-name-for-each-.patch \
	file://0001-configs-socfpga-create-NAND-specific-defconfig-for-A.patch \
	file://0001-configs-socfpga-add-environment-variable-to-load-FPG.patch \
	file://0001-drivers-watchdog-restore-watchdog-default-timeout-va.patch \
	file://0001-include-configs-socfpga-set-mtd3-as-the-default-nand.patch \
	file://0001-arch-arm-psci-implement-psci_system_off-interface-fo.patch \
	file://0001-include-configs-soc64-set-correct-QSPI-clock-for-Agi.patch \
"

inherit deploy

do_compile[deptask] = "do_deploy"

do_compile:prepend() {
	for config in ${UBOOT_MACHINE}; do
		if [ "$config" = "socfpga_stratix10_mmc_defconfig" ];then
			cp ${DEPLOY_DIR_IMAGE}/bl31-stratix10.bin ${S}/bl31-stratix10.bin
		fi
		if [ "$config" = "socfpga_agilex_mmc_defconfig" ];then
			cp ${DEPLOY_DIR_IMAGE}/bl31-agilex.bin ${S}/bl31-agilex.bin
		fi
	done
}

do_install:append() {
	unset i j
	for config in ${UBOOT_MACHINE}; do
		i=$(expr $i + 1);
		for type in ${UBOOT_CONFIG}; do
			j=$(expr $j + 1);
			if [ $j -eq $i ]; then
				cp ${B}/$config/u-boot.itb ${B}/$config/u-boot-${type}.itb
				install -D -m 644 ${B}/$config/u-boot-${type}.itb ${D}/boot/u-boot-${type}-${PV}-${PR}.itb
				ln -sf u-boot-${type}-${PV}-${PR}.itb ${D}/boot/u-boot.itb-${type}
			fi
		done
		unset j
	done
	unset i
	rm -rf  ${D}/boot/*.img*
}

do_deploy:append() {
	unset i j
	for config in ${UBOOT_MACHINE}; do
		install -d ${DEPLOYDIR}/$config
		install -m 744 ${B}/$config/u-boot.img ${DEPLOYDIR}/$config/u-boot.img
		install -m 644 ${B}/$config/u-boot-dtb.img ${DEPLOYDIR}/$config/u-boot-dtb.img
		install -m 644 ${B}/$config/spl/u-boot-spl-dtb.hex ${DEPLOYDIR}/$config/u-boot-spl-dtb.hex
		install -m 744 ${B}/$config/u-boot.itb ${DEPLOYDIR}/$config/u-boot.itb

		i=$(expr $i + 1);
		for type in ${UBOOT_CONFIG}; do
			j=$(expr $j + 1);
			if [ $j -eq $i ]; then
				install -m 744 ${B}/$config/u-boot.img ${DEPLOYDIR}/u-boot-${type}.img
				install -m 644 ${B}/$config/u-boot-dtb.img ${DEPLOYDIR}/u-boot-dtb-${type}.img
				install -m 744 ${B}/$config/u-boot.itb ${DEPLOYDIR}/u-boot-${type}.itb
			fi
		done
		unset j
	done
	unset i

	cd ${DEPLOYDIR}
	if [ -e u-boot.img ]; then
		rm -rf u-boot.img
	fi
	if [ -e u-boot-dtb.img ]; then
		rm -rf u-boot.img
	fi
	if [ -e u-boot.itb ]; then
		rm -rf u-boot.itb
	fi
	ln -sf u-boot-stratix10-socdk-mmc.img u-boot.img
	ln -sf u-boot-dtb-stratix10-socdk-mmc.img u-boot-dtb.img
	ln -sf u-boot-stratix10-socdk-mmc.itb u-boot.itb
	cd -
}

UBOOT_CONFIG[stratix10-socdk-mmc] = "socfpga_stratix10_mmc_defconfig"
UBOOT_CONFIG[agilex-socdk-mmc] = "socfpga_agilex_mmc_defconfig"
UBOOT_CONFIG[agilex-socdk-nand] = "socfpga_agilex_nand_defconfig"

COMPATIBLE_MACHINE ?= "(^$)"
COMPATIBLE_MACHINE:intel-socfpga-64 = "intel-socfpga-64"
