COMPATIBLE_MACHINE_intel-socfpga-64 = "intel-socfpga-64"
ATFPLAT_intel-socfpga-64 = "stratix10 agilex"
EXTRA_OEMAKE_intel-socfpga-64 = ""

do_compile_intel-socfpga-64() {
	for platform in ${ATFPLAT}; do
		makevars="CROSS_COMPILE="${TARGET_PREFIX}" PLAT="$platform" DEPRECATED=1"
		oe_runmake -C ${S} bl31 $makevars
	done
}

do_deploy_intel-socfpga-64() {
	for platform in ${ATFPLAT}; do
		install -d ${DEPLOYDIR}
		install -m 0644 ${S}/build/${platform}/release/bl31.bin ${DEPLOYDIR}/bl31.bin-${platform}-${PV}-${PR}
		ln -sf bl31.bin-${platform}-${PV}-${PR} ${DEPLOYDIR}/bl31-${platform}.bin
	done
}
