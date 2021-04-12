HOMEPAGE = "http://www.denx.de/wiki/U-Boot/WebHome"
SECTION = "bootloaders"
DEPENDS += "flex-native bison-native dtc-native bc-native u-boot-mkimage-native"

LICENSE = "GPLv2+"
LIC_FILES_CHKSUM = "file://Licenses/README;md5=5a7450c57ffe5ae63fd732446b988025"
PE = "1"

require ${COREBASE}/meta/recipes-bsp/u-boot/u-boot.inc

UBOOT_REPO ?= "git://github.com/altera-opensource/u-boot-socfpga.git"
UBOOT_PROT ?= "https"

UBOOT_VERSION_PREFIX ?= "socfpga_"
UBOOT_VERSION ?= "v2020.10"
UBOOT_BRANCH ?= "${UBOOT_VERSION_PREFIX}${UBOOT_VERSION}"

SRCREV ?= "${AUTOREV}"
PV_append = "+git${SRCPV}"

S = "${WORKDIR}/git"
B = "${WORKDIR}/build"

RPROVIDES_${PN} += "u-boot"

SRC_URI = "${UBOOT_REPO};protocol=${UBOOT_PROT};branch=${UBOOT_BRANCH} \
    file://0001-Update-settings-for-ostree.patch \
"

UBOOT_CONFIG[stratix10-socdk] = "socfpga_stratix10_defconfig"
UBOOT_CONFIG[stratix10-socdk-atf] = "socfpga_stratix10_atf_defconfig"
UBOOT_CONFIG[stratix10-socdk-qspi] = "socfpga_stratix10_qspi_defconfig"
UBOOT_CONFIG[stratix10-socdk-qspi-atf] = "socfpga_stratix10_qspi_atf_defconfig"

COMPATIBLE_MACHINE ?= "intel-socfpga-64"
