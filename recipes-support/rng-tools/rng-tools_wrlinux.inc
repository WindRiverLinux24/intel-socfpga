PACKAGECONFIG_remove_intel-socfpga-64="libjitterentropy"
PACKAGECONFIG_libc-musl_remove_intel-socfpga-64="libjitterentropy"

replace_rng_device() {
    sed -i -e "s;/dev/hwrng;/dev/urandom;" "${D}/etc/default/rng-tools"
}

REPLACE_RNG_DEVICE_FUNC ?= ""
REPLACE_RNG_DEVICE_FUNC_intel-socfpga-64 = "replace_rng_device"
do_install[postfuncs] += "${REPLACE_RNG_DEVICE_FUNC}"
