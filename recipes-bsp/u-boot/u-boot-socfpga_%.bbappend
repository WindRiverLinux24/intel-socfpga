FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

DEPENDS:append:intel-socfpga-64 = " coreutils-native u-boot-tools virtual/kernel"
DEPENDS:append:intel-socfpga-64 = " arm-trusted-firmware bash"
DEPENDS:append:intel-socfpga-64 = " s10-u-boot-scr"
DEPENDS:append:intel-socfpga-64 = " ${@bb.utils.contains('MACHINE_FEATURES', 'fcs', ' fcs-prepare fcs-prepare-native python3-dtc python3-dtc-native', '', d)}"

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
	file://0001-Rename-boot-script-when-ostree-is-not-enabled.patch \
	file://0001-arm-dts-socfpga-remove-prefix-signed.patch \
	file://0001-include-configs-specify-kernel.itb-as-bootfile-for-m.patch \
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
		if [ "$config" = "socfpga_agilex_vab_defconfig" ];then
			cp ${DEPLOY_DIR_IMAGE}/Image ${S}/Image
			cp ${DEPLOY_DIR_IMAGE}/socfpga_agilex_socdk.dtb ${S}/linux.dtb
			cp ${DEPLOY_DIR_IMAGE}/bl31-agilex.bin ${S}/bl31-agilex-vab.bin
		fi
	done
}

create_fcs_key(){
	if [ ! -d "${FCS_KEY_DIR}" ];then
		mkdir ${FCS_KEY_DIR} && cd ${FCS_KEY_DIR}

		# Generate Root Key
		${QUARTUS_SHELL} quartus_sign --family=agilex --operation=make_private_pem --curve=secp384r1 --no_passphrase root0.pem
		${QUARTUS_SHELL} quartus_sign --family=agilex --operation=make_public_pem root0.pem root0_public.pem
		${QUARTUS_SHELL} quartus_sign --family=agilex --operation=make_root root0_public.pem root0.qky

		# Generate Signing Keys: FPGA Signing and HPS Software
		${QUARTUS_SHELL} quartus_sign --family=agilex --operation=make_private_pem --curve=secp384r1 --no_passphrase sign0.pem
		${QUARTUS_SHELL} quartus_sign --family=agilex --operation=make_public_pem sign0.pem sign0_public.pem
		${QUARTUS_SHELL} quartus_sign --family=agilex --operation=make_private_pem --curve=secp384r1 --no_passphrase software0.pem
		${QUARTUS_SHELL} quartus_sign --family=agilex --operation=make_public_pem software0.pem software0_public.pem

		# Generate Signature Chains
		${QUARTUS_SHELL} quartus_sign --family=agilex --operation=append_key --previous_pem=root0.pem --previous_qky=root0.qky --permission=14 --cancel=1 --input_pem=sign0_public.pem sign0_cancel1.qky
		${QUARTUS_SHELL} quartus_sign --family=agilex --operation=append_key --previous_pem=root0.pem --previous_qky=root0.qky --permission=0x80 --cancel=3 --input_pem=software0_public.pem software0_cancel3.qky
	fi
}

do_sign_boot_images(){
	if ${@bb.utils.contains('MACHINE_FEATURES', 'fcs', 'true', 'false', d)} && [ ${QUARTUS_SHELL} ]; then
		rm ${B}/intel_fcs -rf
		mkdir -p ${B}/intel_fcs && cd ${B}/intel_fcs
		mkdir files_to_be_sign signed_images work

		cp ${S}/bl31-agilex.bin ${B}/intel_fcs/files_to_be_sign/bl31-agilex-vab.bin
		cp ${B}/socfpga_agilex_vab_defconfig/u-boot.dtb ${B}/socfpga_agilex_vab_defconfig/u-boot-nodtb.bin ${B}/intel_fcs/files_to_be_sign
		cp ${DEPLOY_DIR_IMAGE}/Image ${B}/intel_fcs/files_to_be_sign
		cp ${DEPLOY_DIR_IMAGE}/socfpga_agilex_socdk.dtb ${B}/intel_fcs/files_to_be_sign/linux.dtb

		create_fcs_key

		cd ${B}/intel_fcs/work
		for image in bl31-agilex-vab.bin u-boot.dtb u-boot-nodtb.bin Image linux.dtb; do
			fcs_prepare --hps_cert ../files_to_be_sign/$image -v
			${QUARTUS_SHELL} quartus_sign --family=agilex --operation=SIGN --qky=${HPS_SIGNATURE_CHAIN} --pem=${HPS_PRIVATE_KEY} ./unsigned_cert.ccert ./signed_cert_$image.ccert
			fcs_prepare --finish ./signed_cert_$image.ccert --imagefile ../files_to_be_sign/$image
			mv hps_image_signed.vab ../signed_images/$image
			rm ./*  -rf
		done

		cd ${B}/intel_fcs/signed_images
		${S}/tools/binman/binman --toolpath ${B}/socfpga_agilex_vab_defconfig/tools build -u -d ../files_to_be_sign/u-boot.dtb -O . -i u-boot -I .
		${S}/tools/binman/binman --toolpath ${B}/socfpga_agilex_vab_defconfig/tools build -u -d ../files_to_be_sign/u-boot.dtb -O . -i kernel -I .
		rm ${B}/socfpga_agilex_vab_defconfig/u-boot.itb -rf
		cp ${B}/intel_fcs/signed_images/u-boot.itb ${B}/socfpga_agilex_vab_defconfig
		cp ${B}/intel_fcs/signed_images/kernel.itb ${B}/socfpga_agilex_vab_defconfig
	fi
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
		if  ${@bb.utils.contains('MACHINE_FEATURES', 'fcs', 'true', 'false', d)} && [ "$config" = "socfpga_agilex_vab_defconfig" ]; then
			cp ${ROOT_KEY} ${HPS_PRIVATE_KEY} ${HPS_SIGNATURE_CHAIN} ${DEPLOYDIR}/$config -rf
			install -m 744 ${B}/$config/kernel.itb ${DEPLOYDIR}/$config/kernel.itb
		fi

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
UBOOT_CONFIG[agilex-socdk-vab-mmc] = "socfpga_agilex_vab_defconfig"

COMPATIBLE_MACHINE ?= "(^$)"
COMPATIBLE_MACHINE:intel-socfpga-64 = "intel-socfpga-64"

addtask sign_boot_images after do_compile before do_deploy
