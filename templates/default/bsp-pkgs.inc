IMAGE_INSTALL += "i2c-tools"
IMAGE_INSTALL += "u-boot-socfpga"
IMAGE_INSTALL += "intel-rsu"

INTEL_SOCFPGA_WIC_INC ?= ""
INTEL_SOCFPGA_WIC_INC_intel-socfpga-64 = "make_intel_socfpga_wic.inc"
require ${@bb.utils.contains('PREFERRED_VERSION_u-boot-socfpga', 'v2020.10%', '', 'conf/${INTEL_SOCFPGA_WIC_INC}', d)}
