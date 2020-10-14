HOMEPAGE = "https://github.com/altera-opensource/u-boot-socfpga"
SECTION = "bootloaders"

PV_append = "+git${SRCPV}"

SRC_URI = "git://github.com/altera-opensource/u-boot-socfpga.git;branch=socfpga_v2020.07"

S = "${WORKDIR}/git"

RPROVIDES_${PN} += "u-boot"
