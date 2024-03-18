DESCRIPTION = "GHRD(Golden Hardware Reference Design) is a reference design for Intel System On Chip (SoC) FPGA."
HOMEPAGE = "https://github.com/altera-opensource/ghrd-socfpga"

DEPENDS:append:intel-socfpga-64 = " curl-native u-boot-socfpga"

LICENSE = "MIT & BSD-2-Clause & Proprietary"
LIC_FILES_CHKSUM = "file://license.txt;md5=4fa414bd1a9c16a384d434844568e83f \
		    file://agilex_soc_devkit_ghrd/intel_custom_ip/license.txt;md5=86e94f17d17eeb6a1460ad75ddd5f06e \
"

PV = "QPDS23.2+git${SRCPV}"

S = "${WORKDIR}/git"

SRCREV = "0544b4c3e85ea3423780cf715edcac48d5b61f9c"
SRC_URI = "git://github.com/altera-opensource/ghrd-socfpga.git;protocol=https;branch=master \
	   https://releases.rocketboards.org/release/intel_custom_ip/intel_custom_ip_20210323_04233.tar.gz;name=custom_ip;subdir=git/agilex_soc_devkit_ghrd \
"
SRC_URI[custom_ip.sha256sum] = "2808d05c60ade94af5313c5632bd0db738b71fb066abf24939eef788b0999809"

inherit deploy

COMPATIBLE_MACHINE = "intel-socfpga-64"

do_compile(){
	if [ ! ${QUARTUS_SHELL} ];then
		bberror "Quartus is required to build GHRD, set QUARTUS_SHELL in conf/local.conf"
	fi

	cd ${S}/agilex_soc_devkit_ghrd
	export BOOTS_FIRST=hps
	export HPS_ENABLE_SGMII=0
	export ENABLE_NIOSV_SUBSYS=0
	${QUARTUS_SHELL} make scrub_clean_all
	${QUARTUS_SHELL} make generate_from_tcl
	${QUARTUS_SHELL} make all

	if ${@bb.utils.contains('MACHINE_FEATURES', 'fcs', 'true', 'false', d)};then
		# Enable the QKY key file in the Quartus project, and rebuild to make it work.
		echo "set_global_assignment -name QKY_FILE ${FPGA_SIGNATURE_CHAIN}" >> ghrd_agfb014r24b2e2v.qsf
		rm output_files/ghrd_agfb014r24b2e2v.sof -rf
		${QUARTUS_SHELL} make sof
	fi
}

do_sign_rbf(){
	if ${@bb.utils.contains('MACHINE_FEATURES', 'fcs', 'true', 'false', d)};then
		# Create and sign HPS RBF files.
		cd ${S}/agilex_soc_devkit_ghrd
		${QUARTUS_SHELL} quartus_pfg -c output_files/ghrd_agfb014r24b2e2v.sof ghrd.rbf -o hps_path=${DEPLOY_DIR_IMAGE}/socfpga_agilex_vab_defconfig/u-boot-spl-dtb.hex -o hps=1 -o sign_later=ON
		${QUARTUS_SHELL} quartus_sign --family=agilex --operation=sign --qky=${FPGA_SIGNATURE_CHAIN} --pem=${FPGA_PRIVATE_KEY} ghrd.core.rbf signed_bitstream_core.rbf
		${QUARTUS_SHELL} quartus_sign --family=agilex --operation=sign --qky=${FPGA_SIGNATURE_CHAIN} --pem=${FPGA_PRIVATE_KEY} ghrd.hps.rbf signed_bitstream_hps.rbf
		${QUARTUS_SHELL} quartus_pfg -c signed_bitstream_hps.rbf signed_flash.jic -o device=MT25QU128 -o flash_loader=AGFB014R24B -o mode=ASX4
	fi
}

do_deploy(){
	install -d ${DEPLOYDIR}/agilex_soc_devkit_ghrd
	install -m 0755 ${S}/agilex_soc_devkit_ghrd/output_files/ghrd_agfb014r24b2e2v.sof ${DEPLOYDIR}/agilex_soc_devkit_ghrd/ghrd_agfb014r24b2e2v.sof

	if ${@bb.utils.contains('MACHINE_FEATURES', 'fcs', 'true', 'false', d)};then
		install -m 0755 ${S}/agilex_soc_devkit_ghrd/signed_bitstream_hps.rbf ${DEPLOYDIR}/agilex_soc_devkit_ghrd/signed_bitstream_hps.rbf
		install -m 0755 ${S}/agilex_soc_devkit_ghrd/signed_bitstream_core.rbf ${DEPLOYDIR}/agilex_soc_devkit_ghrd/signed_bitstream_core.rbf
		install -m 0755 ${S}/agilex_soc_devkit_ghrd/signed_flash.jic ${DEPLOYDIR}/agilex_soc_devkit_ghrd/signed_flash.jic
	fi
}

addtask sign_rbf before do_deploy after do_compile
addtask deploy after do_sign_rbf
