require u-boot-socfpga-common.inc
require recipes-bsp/u-boot/u-boot.inc
# This revision is the v2017.09 release
SRCREV = "53ce6e587a478bf613b1af42b49b5beba2dd2f3a"
SRCREV_arm = "2a2102e92e470beec51d8b2dea8323cfc92f92b1"

UBOOT_REPO ?= "git://github.com/altera-opensource/u-boot-socfpga.git"
UBOOT_BRANCH ?= "socfpga_v${PV}"
UBOOT_BRANCH_arm = "socfpga_v${PV}_arria10_bringup"
UBOOT_PROT ?= "http"

SRC_URI = "${UBOOT_REPO};protocol=${UBOOT_PROT};branch=${UBOOT_BRANCH}"

DEPENDS += "dtc-native"
