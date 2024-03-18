DESCRIPTION = "FCS certificate client is a userspace application for interacting \
               with the SDM VAB and SDOS functionality"
HOMEPAGE = "https://github.com/altera-opensource/fcs_apps.git"

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

LICENSE = "GPL-2.0-or-later"
LIC_FILES_CHKSUM = "file://licenses/gpl-2.0.txt;md5=b234ee4d69f5fce4486a80fdaf4a4263 \
                    file://licenses/Linux-syscall-note;md5=6b0dff741019b948dfe290c05d6f361c \
                    file://nettle/COPYINGv2;md5=b234ee4d69f5fce4486a80fdaf4a4263"

PV = "0.1+git${SRCPV}"

S = "${WORKDIR}/git"

BRANCH = "fcs_client"
SRC_URI = "git://github.com/altera-opensource/fcs_apps.git;protocol=http;branch=${BRANCH} \
	   file://0001-fcs-client-building-in-Yocto-environment.patch \
"
SRCREV ?= "3aaadb298ad32bb60603c13bec53b005aae1311b"

EXTRA_OEMAKE = 'CC="${CC}"'
COMPATIBLE_MACHINE = "intel-socfpga-64"

do_compile(){
	oe_runmake all
}

do_install(){
	install -d ${D}${bindir}
	install -m 0755 fcs_client ${D}${bindir}
}
