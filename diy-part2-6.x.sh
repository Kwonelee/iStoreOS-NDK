#!/bin/bash
#===============================================
# Description: DIY script
# File name: diy-script.sh
# Lisence: MIT
# Author: P3TERX
# Blog: https://p3terx.com
#===============================================

# 追加binder内核参数
#echo "CONFIG_PSI=y
#CONFIG_KPROBES=y" >> target/linux/rockchip/armv8/config-6.6

# 集成无线
mkdir -p package/base-files/files/lib/firmware/brcm
cp -a $GITHUB_WORKSPACE/configfiles/firmware/brcm/* package/base-files/files/lib/firmware/brcm/

# ================================================================
# 移植RK3399示例，其他RK3399可模仿
# ================================================================
# 增加tvi3315a设备
echo -e "\\ndefine Device/tvi_tvi3315a
  DEVICE_VENDOR := Tvi
  DEVICE_MODEL := TVI3315A
  SOC := rk3399
  UBOOT_DEVICE_NAME := tvi3315a-rk3399
endef
TARGET_DEVICES += tvi_tvi3315a" >> target/linux/rockchip/image/armv8.mk

# 替换package/boot/uboot-rockchip/Makefile
cp -f $GITHUB_WORKSPACE/configfiles/uboot-rockchip/Makefile package/boot/uboot-rockchip/Makefile

# 复制dts与配置文件到package/boot/uboot-rockchip
cp -f $GITHUB_WORKSPACE/configfiles/dts/rk3399/{rk3399.dtsi,rk3399-opp.dtsi,rk3399-tvi3315a.dts} package/boot/uboot-rockchip/src/arch/arm/dts/
cp -f $GITHUB_WORKSPACE/configfiles/uboot-rockchip/rk3399-tvi3315a-u-boot.dtsi package/boot/uboot-rockchip/src/arch/arm/dts/
cp -f $GITHUB_WORKSPACE/configfiles/uboot-rockchip/tvi3315a-rk3399_defconfig package/boot/uboot-rockchip/src/configs/

# 复制dts到files/arch/arm64/boot/dts/rockchip
cp -f $GITHUB_WORKSPACE/configfiles/dts/rk3399/{rk3399.dtsi,rk3399-opp.dtsi,rk3399-tvi3315a.dts} target/linux/rockchip/files/arch/arm64/boot/dts/rockchip/

# 添加dtb补丁到target/linux/rockchip/patches-6.6
cp -f $GITHUB_WORKSPACE/configfiles/patch/800-add-rk3399-tvi3315a-dtb-to-makefile.patch target/linux/rockchip/patches-6.6/
# ================================================================
# RK3399示例结束
# ================================================================

# ================================================================
# 移植RK3566示例，其他RK35xx可模仿
# ================================================================
# 增加jp-tvbox设备
echo -e "\\ndefine Device/jp_jp-tvbox
\$(call Device/Legacy/rk3566,\$(1))
  DEVICE_VENDOR := Jp
  DEVICE_MODEL := JP TVBOX
  DEVICE_DTS := rk3568/rk3566-jp-tvbox
  SUPPORTED_DEVICES += jp,jp-tvbox
  DEVICE_PACKAGES := kmod-scsi-core
endef
TARGET_DEVICES += jp_jp-tvbox" >> target/linux/rockchip/image/legacy.mk

# 增加oec-turbo设备；据说该设备电路板上印有oec L2.1或1.0啥的，以及原版和改内存CPU版本啥的。需自行判断其影响！
echo -e "\\ndefine Device/wxy_oec-turbo
\$(call Device/Legacy/rk3566,\$(1))
  DEVICE_VENDOR := Wxy
  DEVICE_MODEL := OEC TURBO
  DEVICE_DTS := rk3568/rk3566-wxy-oec-turbo
  SUPPORTED_DEVICES += wxy,oec-turbo
  DEVICE_PACKAGES := kmod-scsi-core
endef
TARGET_DEVICES += wxy_oec-turbo" >> target/linux/rockchip/image/legacy.mk

# 复制dts到target/linux/rockchip/dts/rk3568
cp -f $GITHUB_WORKSPACE/configfiles/dts/rk3568/rk3566-jp-tvbox.dts target/linux/rockchip/dts/rk3568/
cp -f $GITHUB_WORKSPACE/configfiles/dts/rk3568/rk3566-wxy-oec-turbo.dts target/linux/rockchip/dts/rk3568/
# ================================================================
# RK35xx示例结束
# ================================================================

# 定时限速插件
#git clone --depth=1 https://github.com/sirpdboy/luci-app-eqosplus package/luci-app-eqosplus
