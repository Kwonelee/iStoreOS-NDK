#!/bin/bash
#===============================================
# Description: DIY script
# File name: diy-script.sh
# Lisence: MIT
# Author: P3TERX
# Blog: https://p3terx.com
#===============================================

### Devices ###
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

# 增加tv设备
echo -e "\\ndefine Device/rk3399_tvi3315a
  $(Device/Legacy)
  DEVICE_VENDOR := RK3399
  DEVICE_MODEL := tvi3315a
  SOC := rk3399
  SUPPORTED_DEVICES := rk3399,tvi3315a
  DEVICE_DTS := rockchip/rk3399-tvi3315a
  UBOOT_DEVICE_NAME := tvi3315a-rk3399
endef
TARGET_DEVICES += rk3399_tvi3315a" >> target/linux/rockchip/image/legacy.mk

echo -e "\\ndefine Device/rk3399_tvi3315a
  $(Device/Legacy)
  DEVICE_VENDOR := RK3399
  DEVICE_MODEL := tvi3315a
  SOC := rk3399
  SUPPORTED_DEVICES := rk3399,tvi3315a
  DEVICE_DTS := rockchip/rk3399-tvi3315a
  IMAGE/idbloader.bin := cat bin/target/rockchip/rk3399-tvi3315a/idbloader.bin
  IMAGE/trust.bin := cat bin/target/rockchip/rk3399-tvi3315a/trust.bin
  IMAGE/uboot.img := cat bin/target/rockchip/rk3399-tvi3315a/uboot.img
endef
TARGET_DEVICES += rk3399_tvi3315a" >> target/linux/rockchip/image/legacy.mk

mkdir -p bin/target/rockchip/rk3399-tvi3315a/
cp /您的文件路径/uboot.img bin/target/rockchip/rk3399-tvi3315a/
cp /您的文件路径/trust.bin bin/target/rockchip/rk3399-tvi3315a/
cp /您的文件路径/idbloader.bin bin/target/rockchip/rk3399-tvi3315a/
