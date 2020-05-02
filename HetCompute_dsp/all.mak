# pakman min file

android_Release = android_Release/ship
hexagon_Release_dynamic_toolv81_v65 = hexagon_Release_dynamic_toolv81_v65/ship
hexagon_Release_dynamic_toolv72_v55 = hexagon_Release_dynamic_toolv72_v55/ship
hexagon_ReleaseG_dynamic_toolv72_v55 = hexagon_ReleaseG_dynamic_toolv72_v55/ship
hexagon_Debug_dynamic_toolv72_v60 = hexagon_Debug_dynamic_toolv72_v60/ship
android_Debug_aarch64 = android_Debug_aarch64/ship
hexagon_Debug_dynamic_toolv81_v62 = hexagon_Debug_dynamic_toolv81_v62/ship
hexagon_Release_dynamic_toolv81_v62 = hexagon_Release_dynamic_toolv81_v62/ship
UbuntuARM_Debug_aarch64 = UbuntuARM_Debug_aarch64/ship
hexagon_ReleaseG_dynamic_toolv81_v62 = hexagon_ReleaseG_dynamic_toolv81_v62/ship
hexagon_Debug_dynamic_toolv81_v65 = hexagon_Debug_dynamic_toolv81_v65/ship
hexagon_Release_dynamic_toolv81_v60 = hexagon_Release_dynamic_toolv81_v60/ship
MAKE_D_DIR = $(HEXAGON_SDK_ROOT)/build/make.d
android_Debug = android_Debug/ship
android_ReleaseG = android_ReleaseG/ship
UbuntuARM_Release = UbuntuARM_Release/ship
hexagon_ReleaseG_dynamic_toolv81_v65 = hexagon_ReleaseG_dynamic_toolv81_v65/ship
android_ReleaseG_aarch64 = android_ReleaseG_aarch64/ship
hexagon_Release_dynamic_toolv72_v60 = hexagon_Release_dynamic_toolv72_v60/ship
android_Release_aarch64 = android_Release_aarch64/ship
hexagon_ReleaseG_dynamic_toolv81_v60 = hexagon_ReleaseG_dynamic_toolv81_v60/ship
hexagon_Debug_dynamic_toolv72_v55 = hexagon_Debug_dynamic_toolv72_v55/ship
UbuntuARM_Release_aarch64 = UbuntuARM_Release_aarch64/ship
UbuntuARM_ReleaseG = UbuntuARM_ReleaseG/ship
hexagon_Debug_dynamic_toolv81_v60 = hexagon_Debug_dynamic_toolv81_v60/ship
hexagon_ReleaseG_dynamic_toolv72_v60 = hexagon_ReleaseG_dynamic_toolv72_v60/ship
UbuntuARM_Debug = UbuntuARM_Debug/ship
UbuntuARM_ReleaseG_aarch64 = UbuntuARM_ReleaseG_aarch64/ship

# adjust paths to be relative to current working dir
_pkg_deps = android_Release hexagon_Release_dynamic_toolv81_v65 hexagon_Release_dynamic_toolv72_v55 hexagon_ReleaseG_dynamic_toolv72_v55 hexagon_Debug_dynamic_toolv72_v60 android_Debug_aarch64 hexagon_Debug_dynamic_toolv81_v62 hexagon_Release_dynamic_toolv81_v62 UbuntuARM_Debug_aarch64 hexagon_ReleaseG_dynamic_toolv81_v62 hexagon_Debug_dynamic_toolv81_v65 hexagon_Release_dynamic_toolv81_v60 MAKE_D_DIR android_Debug android_ReleaseG UbuntuARM_Release hexagon_ReleaseG_dynamic_toolv81_v65 android_ReleaseG_aarch64 hexagon_Release_dynamic_toolv72_v60 android_Release_aarch64 hexagon_ReleaseG_dynamic_toolv81_v60 hexagon_Debug_dynamic_toolv72_v55 UbuntuARM_Release_aarch64 UbuntuARM_ReleaseG hexagon_Debug_dynamic_toolv81_v60 hexagon_ReleaseG_dynamic_toolv72_v60 UbuntuARM_Debug UbuntuARM_ReleaseG_aarch64
__pkg_dir := $(filter-out ./,$(dir $(lastword $(MAKEFILE_LIST))))
$(foreach v,$(_pkg_deps),$(eval $v := $(__pkg_dir)$$($v)))

# assign these variables only for the top-level makefile
ifeq ($(origin __pkg_root),undefined)
  __pkg_root    := $(__pkg_dir).
  __pkg_result  := $(__pkg_root)$(filter-out /.,/ship)
  __pkg_deps    := $(_pkg_deps)
endif
__pkg_uri     ?= p4://qctp406.qualcomm.com/source/qcom/qct/platform/adsp/proj/HetCompute_dsp/sdk_3.pak
__pkg_version ?= 1231366


include $(MAKE_D_DIR)/defines.min
include glue/all.mak

RESULT_DIRS = $(sort $(filter-out MAKE_D_DIR,$(__pkg_deps)))

OBJ_DIR = ship

$(foreach d,$(RESULT_DIRS),\
    $(eval BUILD_COPIES+=$(wildcard $($d)/*) $(OBJ_DIR)/$d/ ;))

include $(MAKE_D_DIR)/rules.min

build_vs:hexagon_Debug_dynamic_toolv72_v60 hexagon_Release_dynamic_toolv72_v60 hexagon_ReleaseG_dynamic_toolv72_v60 hexagon_Debug_dynamic_toolv72_v55 hexagon_Release_dynamic_toolv72_v55 hexagon_ReleaseG_dynamic_toolv72_v55 android_Debug android_Debug_aarch64 android_Release android_Release_aarch64 android_ReleaseG android_ReleaseG_aarch64

build_vs_clean:hexagon_Debug_dynamic_toolv72_v60_clean hexagon_Release_dynamic_toolv72_v60_clean hexagon_ReleaseG_dynamic_toolv72_v60_clean hexagon_Debug_dynamic_toolv72_v55_clean hexagon_Release_dynamic_toolv72_v55_clean hexagon_ReleaseG_dynamic_toolv72_v55_clean android_Debug_clean android_Debug_aarch64_clean android_Release_clean android_Release_aarch64_clean android_ReleaseG_clean android_ReleaseG_aarch64_clean

