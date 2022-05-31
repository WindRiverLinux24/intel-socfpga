SUMMARY = "U-boot boot scripts for stratix10"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

DEPENDS = "u-boot-mkimage-native dtc-native"

INHIBIT_DEFAULT_DEPS = "1"

SRC_URI = "file://boot.txt \
	file://ghrd.core.rbf \
	file://boot.its \
	"

do_compile() {
	mkimage -f ${WORKDIR}/boot.its u-boot.scr
}

inherit deploy nopackages

do_deploy() {
	install -d ${DEPLOYDIR}
	if ${@bb.utils.contains('DISTRO_FEATURES', 'ostree', 'true', 'false', d)}; then
		# The u-boot.scr is not used when ostree is enabled
		install -m 0644 u-boot.scr ${DEPLOYDIR}
	else
		install -m 0644 u-boot.scr ${DEPLOYDIR}/boot.scr
	fi
	install -m 0644 "${WORKDIR}/ghrd.core.rbf" ${DEPLOYDIR}
}

addtask do_deploy after do_compile before do_build

PACKAGE_ARCH = "${MACHINE_ARCH}"
COMPATIBLE_MACHINE = "intel-socfpga-64"
