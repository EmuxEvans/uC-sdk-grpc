export BOARD = mbed-lpc1768
ROOTDIR = $(CURDIR)/uC-sdk

TARGET = grpc-test.bin
TARGET_SRCS = grpc-test.c
TARGET_CPPFLAGS = -include $(CURDIR)/uC-sdk-port_platform.h -I $(CURDIR)/grpc/include

ifeq ($(VERBOSE),true)
GRPC_MAKE_OPTIONS += V=1
endif

GRPC_OUTPUT_DIR = libs/opt

ifeq ($(DEBUG),true)
GRPC_MAKE_OPTIONS += CONFIG=dbg
GRPC_OUTPUT_DIR = libs/dbg
endif

LIBDEPS = \
$(ROOTDIR)/FreeRTOS/libFreeRTOS.a \
$(ROOTDIR)/arch/libarch.a \
$(ROOTDIR)/os/libos.a \
$(ROOTDIR)/libc/libc.a \
$(ROOTDIR)/libm/libm.a \
$(ROOTDIR)/acorn/libacorn.a \
$(ROOTDIR)/hardware/libhardware.a \
$(ROOTDIR)/chips/libchips.a \
$(ROOTDIR)/lwip/liblwip.a \
$(CURDIR)/grpc/$(GRPC_OUTPUT_DIR)/libgpr_unsecure.a \
$(CURDIR)/grpc/$(GRPC_OUTPUT_DIR)/libgrpc_unsecure.a \

LIBS = -Wl,--start-group $(LIBDEPS) -Wl,--end-group
TARGET_INCLUDES = include

include $(ROOTDIR)/common.mk

all: uC-sdk grpc $(TARGET)

clean: clean-generic
	$(Q)$(MAKE) $(MAKE_OPTS) -C $(CURDIR)/grpc clean
	$(Q)$(MAKE) $(MAKE_OPTS) -C $(ROOTDIR) clean

.PHONY: uC-sdk grpc

$(ROOTDIR)/FreeRTOS/libFreeRTOS.a: uC-sdk
$(ROOTDIR)/arch/libarch.a: uC-sdk
$(ROOTDIR)/os/libos.a: uC-sdk
$(ROOTDIR)/libc/libc.a: uC-sdk
$(ROOTDIR)/libm/libm.a: uC-sdk
$(ROOTDIR)/acorn/libacorn.a: uC-sdk
$(ROOTDIR)/hardware/libhardware.a: uC-sdk
$(ROOTDIR)/chips/libchips.a: uC-sdk
$(ROOTDIR)/lwip/liblwip.a: uC-sdk

uC-sdk:
	$(E) "[MAKE]   Entering uC-sdk"
	$(Q)$(MAKE) $(MAKE_OPTS) -C $(ROOTDIR)

deps: ldeps
	$(E) "[DEPS]   Creating dependency tree for uC-sdk"
	$(Q)$(MAKE) $(MAKE_OPTS) -C $(ROOTDIR) ldeps

include $(ROOTDIR)/FreeRTOS/config.mk
include $(ROOTDIR)/arch/config.mk
include $(ROOTDIR)/os/config.mk
include $(ROOTDIR)/libc/config.mk
include $(ROOTDIR)/libm/config.mk
include $(ROOTDIR)/acorn/config.mk
include $(ROOTDIR)/hardware/config.mk
include $(ROOTDIR)/chips/config.mk
include $(ROOTDIR)/lwip/config.mk
include $(ROOTDIR)/target-rules.mk

GRPC_MAKE_OPTIONS += CC=$(TARGET_CC) AR=$(TARGET_AR)
GRPC_CPPFLAGS = \
-ffunction-sections -Wall -Werror $(addprefix -I, $(TARGET_INCLUDES)) \
$(TARGET_CPPFLAGS) -include $(CURDIR)/uC-sdk-grpc-defines.h -I$(CURDIR)/grpc \
-I$(CURDIR)/zlib

grpc:
	$(E) "[MAKE]   Entering grpc"
	$(Q)$(MAKE) $(MAKE_OPTS) -C $(CURDIR)/grpc $(GRPC_MAKE_OPTIONS) \
	    CPPFLAGS="$(GRPC_CPPFLAGS)" CFLAGS="-std=c11" \
	    $(GRPC_OUTPUT_DIR)/libgpr.a $(GRPC_OUTPUT_DIR)/libgrpc_unsecure.a
