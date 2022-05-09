#
# Copyright (C) 2021 Wind River Systems, Inc.
#

COMPATIBLE_MACHINE:intel-socfpga-64 = "intel-socfpga-64"
TARGET_SUPPORTED_KTYPES:intel-socfpga-64 = "standard preempt-rt"

KERNEL_VERSION_SANITY_SKIP = "1"
SRCREV_machine:intel-socfpga-64 ?= "${AUTOREV}"
SRCREV_meta:intel-socfpga-64 ?= "${AUTOREV}"
