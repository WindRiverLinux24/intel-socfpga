DESCRIPTION = "FCS certificate generator is a userspace application for creating the \
               unsigned certificates for VAB image validation, VAB Counter Set, and VAB Key Cancellation."
HOMEPAGE = "https://github.com/altera-opensource/fcs_apps.git"

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

LICENSE = "GPL-2.0-or-later"
LIC_FILES_CHKSUM = "file://licenses/gpl-2.0.txt;md5=b234ee4d69f5fce4486a80fdaf4a4263 \
                    file://nettle/COPYINGv2;md5=b234ee4d69f5fce4486a80fdaf4a4263"

PV = "0.1+git${SRCPV}"

S = "${WORKDIR}/git"

BRANCH = "fcs_prepare"
SRC_URI = "git://github.com/altera-opensource/fcs_apps.git;protocol=http;branch=${BRANCH} \
	   file://0001-fcs_prepare-building-in-Yocto-environment.patch \
	   file://0002-fcs_prepare-Use-dynamic-linking.patch \
"
SRCREV ?= "d88b31c679750800cb39910a24cbbdc32d003b4e"

do_compile(){
	oe_runmake all
}

do_install(){
	install -d ${D}${bindir}
	install -m 0755 fcs_prepare ${D}${bindir}
}

BBCLASSEXTEND = "native nativesdk"
