# This revision is the v2017.09 release
SRCREV_intel-socfpga-64 = "c85cd1fc1331210f1c22adb29d932d4052f79c78"

LIC_FILES_CHKSUM_intel-socfpga-64 = "file://Licenses/README;md5=a2c678cfd4a4d97135585cad908541c6"

PV_intel-socfpga-64 = "2017.09"

DEPENDS_intel-socfpga-64 += "dtc-native"

# the following variables can be passed from the env
# using BB_ENV_WHITELIST to override the defaults
UBOOT_REPO_intel-socfpga-64 ?= "git://github.com/altera-opensource/u-boot-socfpga.git"
UBOOT_BRANCH_intel-socfpga-64 ?= "socfpga_v${PV}"
UBOOT_PROT_intel-socfpga-64 ?= "http"

SRC_URI_intel-socfpga-64 = "${UBOOT_REPO};protocol=${UBOOT_PROT};branch=${UBOOT_BRANCH}"
