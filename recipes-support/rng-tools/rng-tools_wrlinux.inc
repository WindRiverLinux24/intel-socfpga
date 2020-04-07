PACKAGECONFIG_remove_intel-socfpga-64="libjitterentropy"
PACKAGECONFIG_libc-musl_remove_intel-socfpga-64="libjitterentropy"

replace_rng_device() {
    sed -i -e "/^EnvironmentFile=.*/d" "${D}${systemd_system_unitdir}/rngd.service"
    sed -i -e "s;^ExecStart=.*;ExecStart=${sbindir}/rngd -f -r /dev/urandom;" "${D}${systemd_system_unitdir}/rngd.service"
}

do_install[postfuncs] += " replace_rng_device "
