LINUXINCLUDE := \
    -I$(src)/include \
    -I$(src)/include/drm \
    -I$(src)/include/uapi \
    -include $(obj)/rename_symbol.h \
    $(LINUXINCLUDE)

export LINUXINCLUDE

export CONFIG_HSA_AMD=m
export CONFIG_DRM_TTM=m
export CONFIG_DRM_AMDGPU=m
export CONFIG_DRM_SCHED=m
export CONFIG_DRM_AMDGPU_CIK=y
export CONFIG_DRM_AMDGPU_SI=y
export CONFIG_DRM_AMDGPU_USERPTR=y
export CONFIG_DRM_AMD_DC=y
export CONFIG_DRM_AMD_DC_DCN1_0=y
export CONFIG_DRM_AMD_DC_DCN1_01=y

subdir-ccflags-y += -DCONFIG_HSA_AMD
subdir-ccflags-y += -DCONFIG_DRM_AMDGPU_CIK
subdir-ccflags-y += -DCONFIG_DRM_AMDGPU_SI
subdir-ccflags-y += -DCONFIG_DRM_AMDGPU_USERPTR
subdir-ccflags-y += -DCONFIG_DRM_AMD_DC
subdir-ccflags-y += -DCONFIG_DRM_AMD_DC_DCN1_0
subdir-ccflags-y += -DCONFIG_DRM_AMD_DC_DCN1_01

$(obj)/rename_symbol.h: $(shell find $(src)/ttm $(src)/scheduler -name '*.c')
	grep -h EXPORT_SYMBOL $^ | awk -F'[()]' '{print "#define "$2" amd"$2" //"$0}' >$@

always := rename_symbol.h

obj-m += scheduler/ amd/amdgpu/ ttm/
