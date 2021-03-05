#
# Copyright (C) 2021 Wind River Systems, Inc.
#

COMPATIBLE_MACHINE_intel-socfpga-64 = "intel-socfpga-64"
TARGET_SUPPORTED_KTYPES_intel-socfpga-64 = "standard"

KERNEL_VERSION_SANITY_SKIP = "1"
SRCREV_machine_intel-socfpga-64 ?= "${AUTOREV}"
SRCREV_meta_intel-socfpga-64 ?= "${AUTOREV}"
