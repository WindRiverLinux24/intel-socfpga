require linux-yocto-intel-socfpga.inc

KBRANCH_intel-socfpga-64 = "v5.10/standard/intel-sdk-5.10/intel-socfpga"

LINUX_VERSION_intel-socfpga-64 ?= "5.10.x"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI_append_intel-socfpga-64 = " \
	file://0001-firmware-stratix10-svc-remove-the-condition-for-not-.patch \
"
