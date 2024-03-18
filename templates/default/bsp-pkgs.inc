IMAGE_INSTALL += "i2c-tools"
IMAGE_INSTALL += "u-boot-socfpga"
IMAGE_INSTALL += "intel-rsu"
IMAGE_INSTALL += "fcs-client"

INTEL_SOCFPGA_WIC_INC ?= ""
INTEL_SOCFPGA_WIC_INC:intel-socfpga-64 = "make_intel_socfpga_wic.inc"
require conf/${INTEL_SOCFPGA_WIC_INC}
