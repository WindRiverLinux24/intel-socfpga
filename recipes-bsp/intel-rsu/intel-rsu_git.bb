SUMMARY = "Intel Remote System Update Tool"
HOMEPAGE = "https://github.com/altera-opensource/intel-rsu"
SECTION = "intel-rsu"
LICENSE = "GPLv2+"
LIC_FILES_CHKSUM = "file://etc/qspi.rc;md5=11ed0a5e56ff53304b1e6192fde53286"

DEPENDS = "zlib"

PV = "1.0.0"

S = "${WORKDIR}/git"

FILES_${PN} += "${libdir}/librsu.so"
FILES_${PN}-dev = "${includedir}"

SRC_URI = "git://github.com/altera-opensource/intel-rsu.git;protocol=http;branch=master \
	file://0001-intel-rsu-modify-makefile-to-be-compatible-with-yoct.patch"
SRCREV = "a9e07539bb5cda0305e84e0d62654bfb0fb28f01"

EXTRA_OEMAKE = 'CROSS_COMPILE=${TARGET_PREFIX} CC="${CC} ${TOOLCHAIN_OPTIONS}"'
EXTRA_OEMAKE += 'HOSTCC="${BUILD_CC} ${BUILD_CFLAGS} ${BUILD_LDFLAGS}"'


do_compile () {
    oe_runmake -C ${S}/lib all
    oe_runmake -C ${S}/example all
}

do_install () {
    oe_runmake -C ${S}/lib install DESTDIR=${D}
    oe_runmake -C ${S}/example install DESTDIR=${D}
    install -d ${D}/etc
    install -m 755 ${S}/etc/qspi.rc ${D}/etc/librsu.rc
    install -m 755 -d ${D}${includedir}
    install -m 755 ${S}/lib/*.h ${D}${includedir}
}
