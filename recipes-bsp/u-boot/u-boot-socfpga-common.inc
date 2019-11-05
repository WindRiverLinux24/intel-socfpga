HOMEPAGE = "https://github.com/altera-opensource/u-boot-socfpga"
SECTION = "bootloaders"

PV_append = "+git${SRCPV}"

SRC_URI = "git://github.com/altera-opensource/u-boot-socfpga.git;branch=socfpga_v2019.04"

S = "${WORKDIR}/git"

RPROVIDES_${PN} += "u-boot"
