FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

DEPENDS_append_intel-socfpga-64 = " coreutils-native u-boot-tools virtual/kernel"
DEPENDS_append_intel-socfpga-64 = " arm-trusted-firmware bash"
DEPENDS_append_intel-socfpga-64 = " s10-u-boot-scr"

SRC_URI_intel-socfpga-64 = "${UBOOT_REPO};protocol=${UBOOT_PROT};nobranch=1"
SRCREV_intel-socfpga-64 = "${@bb.utils.contains('UBOOT_VERSION', 'v2020.10', \
		'584a2391639d89cff6476bbfbdf7d9c666970661', \
		'ee63370553cd01f7237174fe1971991271b7648b', d)}"

SRC_URI_append_intel-socfpga-64 = " \
	file://0001-driver-watchdog-reset-watchdog-in-designware_wdt_sto.patch \
	${@bb.utils.contains('UBOOT_VERSION', 'v2020.10', \
		'file://0001-driver-watchdog-enable-wdt-command-by-default-v2020-10.patch \
		 file://0001-Update-settings-for-ostree-for-u-boot-socfpga-v2020..patch ', \
		'file://0001-driver-watchdog-enable-wdt-command-by-default.patch \
		 file://0001-Update-settings-for-ostree.patch \
		 file://0001-configs-socfpga-create-MMC-specific-defconfig-for-st.patch \
		 file://0001-configs-socfpga-create-MMC-specific-defconfig-for-ag.patch \
		 file://0001-arm-dts-socfpga-set-specific-atf-file-name-for-each-.patch', d)} \
	file://0001-arch-arm-psci-implement-psci_system_off-interface-fo.patch \
"

inherit deploy

do_compile[deptask] = "do_deploy"

do_compile_prepend() {
	if ${@bb.utils.contains("MACHINE", "intel-socfpga-64", "true", "false", d)}; then
		if ! ${@bb.utils.contains("UBOOT_VERSION", "v2020.10", "true", "false", d)}; then
			for config in ${UBOOT_MACHINE}; do
				if [ "$config" = "socfpga_stratix10_mmc_defconfig" ];then
					cp ${DEPLOY_DIR_IMAGE}/bl31-stratix10.bin ${S}/bl31-stratix10.bin
				fi
				if [ "$config" = "socfpga_agilex_mmc_defconfig" ];then
					cp ${DEPLOY_DIR_IMAGE}/bl31-agilex.bin ${S}/bl31-agilex.bin
				fi
			done
		fi
	fi
}

do_compile_append() {
	if ${@bb.utils.contains("MACHINE", "intel-socfpga-64", "true", "false", d)}; then
		if ${@bb.utils.contains("UBOOT_VERSION", "v2020.10", "true", "false", d)}; then
			for config in ${UBOOT_MACHINE}; do
				if [ "$config" = "socfpga_stratix10_atf_defconfig" ];then
					cp ${DEPLOY_DIR_IMAGE}/bl31.bin ${B}/$config/bl31.bin
					oe_runmake -C ${S} O=${B}/$config u-boot.itb
				fi
			done
		fi
	fi
}

do_install_append() {
	if ! ${@bb.utils.contains("UBOOT_VERSION", "v2020.10", "true", "false", d)}; then
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
	fi
}

do_deploy_append() {
	if ${@bb.utils.contains("MACHINE", "intel-socfpga-64", "true", "false", d)}; then
		if ${@bb.utils.contains("UBOOT_VERSION", "v2020.10", "true", "false", d)}; then
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
		else
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
		fi
	fi
}

UBOOT_CONFIG[stratix10-socdk-mmc] = "socfpga_stratix10_mmc_defconfig"
UBOOT_CONFIG[agilex-socdk-mmc] = "socfpga_agilex_mmc_defconfig"

COMPATIBLE_MACHINE ?= "(^$)"
COMPATIBLE_MACHINE_intel-socfpga-64 = "intel-socfpga-64"
