# pakman tree build file
_@ ?= @

.PHONY: MAKE_D_6_INCDIR QAIC_DIR MAKE_D_EXT_4_DIR MAKE_D_2_LIBDIR MAKE_D_4_INCDIR MAKE_D_6_LIBDIR tree MAKE_D_6_INCDIR_clean QAIC_DIR_clean MAKE_D_EXT_4_DIR_clean MAKE_D_2_LIBDIR_clean MAKE_D_4_INCDIR_clean MAKE_D_6_LIBDIR_clean tree_clean

tree: MAKE_D_6_INCDIR MAKE_D_EXT_4_DIR MAKE_D_4_INCDIR MAKE_D_2_LIBDIR MAKE_D_2_LIBDIR MAKE_D_6_INCDIR MAKE_D_4_INCDIR MAKE_D_6_LIBDIR MAKE_D_6_LIBDIR
	$(call job,,$(MAKE) V=hexagon_Release_dynamic_toolv81_v62,making .)

tree_clean: MAKE_D_6_INCDIR_clean MAKE_D_EXT_4_DIR_clean MAKE_D_4_INCDIR_clean MAKE_D_2_LIBDIR_clean MAKE_D_2_LIBDIR_clean MAKE_D_6_INCDIR_clean MAKE_D_4_INCDIR_clean MAKE_D_6_LIBDIR_clean MAKE_D_6_LIBDIR_clean
	$(call job,,$(MAKE) V=hexagon_Release_dynamic_toolv81_v62 clean,cleaning .)

MAKE_D_6_LIBDIR: 
	$(call job,$(HEXAGON_SDK_ROOT)/test/common/test_main,$(MAKE) V=hexagon_Release_dynamic_toolv81_v62,making $(HEXAGON_SDK_ROOT)/test/common/test_main)

MAKE_D_6_LIBDIR_clean: 
	$(call job,$(HEXAGON_SDK_ROOT)/test/common/test_main,$(MAKE) V=hexagon_Release_dynamic_toolv81_v62 clean,cleaning $(HEXAGON_SDK_ROOT)/test/common/test_main)

MAKE_D_4_INCDIR: MAKE_D_2_LIBDIR MAKE_D_EXT_4_DIR MAKE_D_6_INCDIR
	$(call job,$(HEXAGON_SDK_ROOT)/libs/common/rpcmem,$(MAKE) V=hexagon_Release_dynamic_toolv81_v62,making $(HEXAGON_SDK_ROOT)/libs/common/rpcmem)

MAKE_D_4_INCDIR_clean: MAKE_D_2_LIBDIR_clean MAKE_D_EXT_4_DIR_clean MAKE_D_6_INCDIR_clean
	$(call job,$(HEXAGON_SDK_ROOT)/libs/common/rpcmem,$(MAKE) V=hexagon_Release_dynamic_toolv81_v62 clean,cleaning $(HEXAGON_SDK_ROOT)/libs/common/rpcmem)

MAKE_D_2_LIBDIR: 
	$(call job,$(HEXAGON_SDK_ROOT)/libs/common/atomic,$(MAKE) V=hexagon_Release_dynamic_toolv81_v62,making $(HEXAGON_SDK_ROOT)/libs/common/atomic)

MAKE_D_2_LIBDIR_clean: 
	$(call job,$(HEXAGON_SDK_ROOT)/libs/common/atomic,$(MAKE) V=hexagon_Release_dynamic_toolv81_v62 clean,cleaning $(HEXAGON_SDK_ROOT)/libs/common/atomic)

MAKE_D_EXT_4_DIR: QAIC_DIR

MAKE_D_EXT_4_DIR_clean: QAIC_DIR_clean

QAIC_DIR: 
	$(call job,$(HEXAGON_SDK_ROOT)/tools/qaic,make,making $(HEXAGON_SDK_ROOT)/tools/qaic)

QAIC_DIR_clean: 
	$(call job,$(HEXAGON_SDK_ROOT)/tools/qaic,make clean,cleaning $(HEXAGON_SDK_ROOT)/tools/qaic)

MAKE_D_6_INCDIR: 
	$(call job,$(HEXAGON_SDK_ROOT)/test/common/test_util,$(MAKE) V=hexagon_Release_dynamic_toolv81_v62,making $(HEXAGON_SDK_ROOT)/test/common/test_util)

MAKE_D_6_INCDIR_clean: 
	$(call job,$(HEXAGON_SDK_ROOT)/test/common/test_util,$(MAKE) V=hexagon_Release_dynamic_toolv81_v62 clean,cleaning $(HEXAGON_SDK_ROOT)/test/common/test_util)

W := $(findstring ECHO,$(shell echo))# W => Windows environment
@LOG = $(if $W,$(TEMP)\\)$@-build.log

C = $(if $1,cd $1 && )$2
job = $(_@)echo $3 && ( $C )> $(@LOG) && $(if $W,del,rm) $(@LOG) || ( echo ERROR $3 && $(if $W,type,cat) $(@LOG) && $(if $W,del,rm) $(@LOG) && exit 1)
ifdef VERBOSE
  job = $(_@)echo $3 && $C
endif
