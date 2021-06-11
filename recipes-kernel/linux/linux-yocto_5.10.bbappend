require linux-yocto-intel-socfpga.inc

KBRANCH_intel-socfpga-64 = "v5.10/standard/intel-sdk-5.10/intel-socfpga"

LINUX_VERSION_intel-socfpga-64 ?= "5.10.x"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI_append_intel-socfpga-64 = " \
    file://0001-arm64-dts-n5x-Add-support-for-Intel-s-eASIC-N5X-plat.patch \
    file://0002-clk-socfpga-agilex-add-clock-driver-for-eASIC-N5X-pl.patch \
    file://0003-arm64-dts-n5x-Add-gmac-entry.patch \
    file://0004-HSD-22012255070-crypto-intel_fcs-reset-the-min.-and-.patch \
    file://0005-firmware-stratix10-svc-add-COMMAND_AUTHENTICATE_BITS.patch \
    file://0006-firmware-stratix10-svc-extend-SVC-driver-to-get-the-.patch \
    file://0007-fpga-fpga-mgr-add-FPGA_MGR_BITSTREAM_AUTHENTICATE-fl.patch \
    file://0008-fpga-of-fpga-region-add-authenticate-fpga-config-pro.patch \
    file://0009-dt-bindings-fpga-add-authenticate-fpga-config-proper.patch \
    file://0010-fpga-stratix10-soc-extend-driver-for-bitstream-authe.patch \
    file://0011-clocksource-drivers-dw_apb_timer_of-Add-handling-for.patch \
    file://0012-HSD-22012814951-1-intel_fcs-don-t-report-error-with-.patch \
    file://0013-HSD-22012814951-2-intel_fcs-replace-__u32-with-uint3.patch \
"
