#!/bin/bash
#===============================================
# Description: DIY script
# File name: diy-script.sh
# Lisence: MIT
# Author: P3TERX
# Blog: https://p3terx.com
#===============================================

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




# 增加m2设备
echo -e "\\ndefine Device/firefly_station-m2
\$(call Device/Legacy/rk3566,\$(1))
  DEVICE_VENDOR := Firefly
  DEVICE_MODEL := Station M2 / RK3566 ROC PC
  DEVICE_DTS := rk3568/rk3566-roc-pc
  SUPPORTED_DEVICES += rockchip,rk3566-roc-pc firefly,rk3566-roc-pc firefly,station-m2
  DEVICE_PACKAGES := kmod-nvme kmod-scsi-core
endef
TARGET_DEVICES += firefly_station-m2" >> target/linux/rockchip/image/legacy.mk
