# pakman tree build file
_@ ?= @

.PHONY: MAKE_D_2_LIBDIR_MAKE_D_2_LIBDIR QAIC_DIR MAKE_D_2_LIBDIR_MAKE_D_EXT_4_DIR MAKE_D_1_LIBDIR MAKE_D_2_LIBDIR tree MAKE_D_2_LIBDIR_MAKE_D_2_LIBDIR_clean QAIC_DIR_clean MAKE_D_2_LIBDIR_MAKE_D_EXT_4_DIR_clean MAKE_D_1_LIBDIR_clean MAKE_D_2_LIBDIR_clean tree_clean

tree: MAKE_D_2_LIBDIR MAKE_D_2_LIBDIR_MAKE_D_EXT_4_DIR MAKE_D_2_LIBDIR MAKE_D_2_LIBDIR_MAKE_D_2_LIBDIR
	$(call job,,$(MAKE) V=UbuntuARM_Release,making .)

tree_clean: MAKE_D_2_LIBDIR_clean MAKE_D_2_LIBDIR_MAKE_D_EXT_4_DIR_clean MAKE_D_2_LIBDIR_clean MAKE_D_2_LIBDIR_MAKE_D_2_LIBDIR_clean
	$(call job,,$(MAKE) V=UbuntuARM_Release clean,cleaning .)

MAKE_D_2_LIBDIR: MAKE_D_2_LIBDIR_MAKE_D_2_LIBDIR MAKE_D_2_LIBDIR_MAKE_D_EXT_4_DIR MAKE_D_1_LIBDIR
	$(call job,$(HEXAGON_SDK_ROOT)/libs/common/rpcmem,$(MAKE) V=UbuntuARM_Release,making $(HEXAGON_SDK_ROOT)/libs/common/rpcmem)

MAKE_D_2_LIBDIR_clean: MAKE_D_2_LIBDIR_MAKE_D_2_LIBDIR_clean MAKE_D_2_LIBDIR_MAKE_D_EXT_4_DIR_clean MAKE_D_1_LIBDIR_clean
	$(call job,$(HEXAGON_SDK_ROOT)/libs/common/rpcmem,$(MAKE) V=UbuntuARM_Release clean,cleaning $(HEXAGON_SDK_ROOT)/libs/common/rpcmem)

MAKE_D_1_LIBDIR: 
	$(call job,$(HEXAGON_SDK_ROOT)/test/common/test_util,$(MAKE) V=UbuntuARM_Release,making $(HEXAGON_SDK_ROOT)/test/common/test_util)

MAKE_D_1_LIBDIR_clean: 
	$(call job,$(HEXAGON_SDK_ROOT)/test/common/test_util,$(MAKE) V=UbuntuARM_Release clean,cleaning $(HEXAGON_SDK_ROOT)/test/common/test_util)

MAKE_D_2_LIBDIR_MAKE_D_EXT_4_DIR: QAIC_DIR

MAKE_D_2_LIBDIR_MAKE_D_EXT_4_DIR_clean: QAIC_DIR_clean

QAIC_DIR: 
	$(call job,$(HEXAGON_SDK_ROOT)/tools/qaic,make,making $(HEXAGON_SDK_ROOT)/tools/qaic)

QAIC_DIR_clean: 
	$(call job,$(HEXAGON_SDK_ROOT)/tools/qaic,make clean,cleaning $(HEXAGON_SDK_ROOT)/tools/qaic)

MAKE_D_2_LIBDIR_MAKE_D_2_LIBDIR: 
	$(call job,$(HEXAGON_SDK_ROOT)/libs/common/atomic,$(MAKE) V=UbuntuARM_Release,making $(HEXAGON_SDK_ROOT)/libs/common/atomic)

MAKE_D_2_LIBDIR_MAKE_D_2_LIBDIR_clean: 
	$(call job,$(HEXAGON_SDK_ROOT)/libs/common/atomic,$(MAKE) V=UbuntuARM_Release clean,cleaning $(HEXAGON_SDK_ROOT)/libs/common/atomic)

W := $(findstring ECHO,$(shell echo))# W => Windows environment
@LOG = $(if $W,$(TEMP)\\)$@-build.log

C = $(if $1,cd $1 && )$2
job = $(_@)echo $3 && ( $C )> $(@LOG) && $(if $W,del,rm) $(@LOG) || ( echo ERROR $3 && $(if $W,type,cat) $(@LOG) && $(if $W,del,rm) $(@LOG) && exit 1)
ifdef VERBOSE
  job = $(_@)echo $3 && $C
endif
