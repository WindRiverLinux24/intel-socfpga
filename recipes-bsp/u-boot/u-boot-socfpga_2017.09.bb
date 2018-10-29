require u-boot-socfpga-common.inc
require recipes-bsp/u-boot/u-boot.inc
# This revision is the v2017.09 release
SRCREV = "a0e10719289295a0cea1a3b35fedefb2539bdbb3"
SRCREV_arm = "2a2102e92e470beec51d8b2dea8323cfc92f92b1"

UBOOT_REPO ?= "git://github.com/altera-opensource/u-boot-socfpga.git"
UBOOT_BRANCH ?= "socfpga_v${PV}"
UBOOT_BRANCH_arm = "socfpga_v${PV}_arria10_bringup"
UBOOT_PROT ?= "http"

SRC_URI = "${UBOOT_REPO};protocol=${UBOOT_PROT};branch=${UBOOT_BRANCH} \
	file://0001-u-boot-aarch64-libfdt-Remove-leading-underscores.patch \
	file://0002-u-boot-armv8-psci-improve-PSCI_TABLE-define-to-be-co.patch \
	file://0001-arch-arm-psci-implement-psci_system_off-interface-fo.patch"

SRC_URI_arm = "${UBOOT_REPO};protocol=${UBOOT_PROT};branch=${UBOOT_BRANCH} \
	file://0001-u-boot-arm-libfdt-Remove-leading-underscores.patch"

DEPENDS += "dtc-native"
