###RK3399移植调整文件如下（方式二），单网口不需要改网络配置文件

# 增加tv设备
echo -e "\\ndefine Device/Legacy/rk3399
$(call Device/Legacy,$(1))
  SOC := rk3399
  BOOT_SCRIPT := default
endef" >> target/linux/rockchip/image/legacy.mk

echo -e "\\ndefine Device/tvi_tvi3315a
$(call Device/Legacy/rk3399,$(1))
  DEVICE_VENDOR := Tvi
  DEVICE_MODEL := TVI3315A
  SOC := rk3399
  DEVICE_DTS := rk3399/rk3399-tvi3315a   #命名规范时可去掉
  UBOOT_DEVICE_NAME := tvi3315a-rk3399   #命名规范时可去掉
endef
TARGET_DEVICES += tvi_tvi3315a" >> target/linux/rockchip/image/legacy.mk

# 替换uboot-rockchip/Makefile
cp -f $GITHUB_WORKSPACE/configfiles/uboot-rockchip/Makefile package/boot/uboot-rockchip/Makefile

# 复制配置文件到uboot-rockchip
cp -f $GITHUB_WORKSPACE/configfiles/dts/rk3399/rk3399-tvi3315a.dts package/boot/uboot-rockchip/src/arch/arm/dts/
cp -f $GITHUB_WORKSPACE/configfiles/uboot-rockchip/rk3399-tvi3315a-u-boot.dtsi package/boot/uboot-rockchip/src/arch/arm/dts/
cp -f $GITHUB_WORKSPACE/configfiles/uboot-rockchip/tvi3315a-rk3399_defconfig package/boot/uboot-rockchip/src/configs/

# 复制dts设备树文件到指定目录下
cp -f $GITHUB_WORKSPACE/configfiles/dts/rk3399/rk3399-tvi3315a.dts target/linux/rockchip/dts/rk3399/

# 添加dtb补丁
cp -f $GITHUB_WORKSPACE/configfiles/patch/900-add-rk3399-tvi3315a-dtb-to-makefile.patch target/linux/rockchip/patches-6.6/




### 官方提供继承的两个默认配置参考 ###
define Device/Default
  PROFILES := Default
  KERNEL = kernel-bin | lzma | fit lzma $$(DTS_DIR)/$$(DEVICE_DTS).dtb
  BOOT_SCRIPT :=
  IMAGES := sysupgrade.img.gz
  IMAGE/sysupgrade.img.gz = boot-common | boot-script $$(BOOT_SCRIPT) | pine64-img | gzip | append-metadata
  DEVICE_DTS = rockchip/$$(SOC)-$(lastword $(subst _, ,$(1)))
  UBOOT_DEVICE_NAME = $(lastword $(subst _, ,$(1)))-$$(SOC)
endef

define Device/Legacy
  KERNEL = kernel-bin
  DEVICE_DTS_DIR := ../dts
  DEVICE_DTS = $$(SOC)/$$(SOC)-$(lastword $(subst _, ,$(1)))
  IMAGE/sysupgrade.img.gz = boot-common-legacy | boot-script-legacy $$(BOOT_SCRIPT) | pine64-img | gzip | append-metadata
endef
