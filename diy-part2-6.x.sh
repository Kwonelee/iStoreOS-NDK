#!/bin/bash
#===============================================
# Description: DIY script
# File name: diy-script.sh
# Lisence: MIT
# Author: P3TERX
# Blog: https://p3terx.com
#===============================================

# 修改uhttpd配置文件，启用nginx
# sed -i "/.*uhttpd.*/d" .config
# sed -i '/.*\/etc\/init.d.*/d' package/network/services/uhttpd/Makefile
# sed -i '/.*.\/files\/uhttpd.init.*/d' package/network/services/uhttpd/Makefile
#sed -i "s/:80/:81/g" package/network/services/uhttpd/files/uhttpd.config
#sed -i "s/:443/:4443/g" package/network/services/uhttpd/files/uhttpd.config
#cp -a $GITHUB_WORKSPACE/configfiles/etc/* package/base-files/files/etc/
# ls package/base-files/files/etc/

# 追加binder内核参数
#echo "CONFIG_PSI=y
#CONFIG_KPROBES=y" >> target/linux/rockchip/armv8/config-6.6

# 集成CPU性能跑分脚本
#cp -a $GITHUB_WORKSPACE/configfiles/coremark/* package/base-files/files/bin/
#chmod 755 package/base-files/files/bin/coremark
#chmod 755 package/base-files/files/bin/coremark.sh

# 集成无线
mkdir -p package/base-files/files/lib/firmware/brcm/
cp -a $GITHUB_WORKSPACE/configfiles/firmware/brcm/* package/base-files/files/lib/firmware/brcm/

# 增加m2设备
echo -e "\\ndefine Device/firefly_station-m2
\$(call Device/Legacy/rk3566,\$(1))
  DEVICE_VENDOR := Firefly
  DEVICE_MODEL := Station M2 / RK3566 ROC PC
  DEVICE_DTS := rk3568/rk3566-roc-pc
  SUPPORTED_DEVICES += firefly,rk3566-roc-pc firefly,station-m2
  DEVICE_PACKAGES := kmod-nvme kmod-scsi-core
endef
TARGET_DEVICES += firefly_station-m2" >> target/linux/rockchip/image/legacy.mk

# 增加tv设备
echo -e "\\ndefine Device/tvi_tvi3315a
  DEVICE_VENDOR := Tvi
  DEVICE_MODEL := TVI3315A
  SOC := rk3399
  UBOOT_DEVICE_NAME := tvi3315a-rk3399
endef
TARGET_DEVICES += tvi_tvi3315a" >> target/linux/rockchip/image/armv8.mk

# 替换uboot-rockchip/Makefile
cp -f $GITHUB_WORKSPACE/configfiles/uboot-rockchip/Makefile package/boot/uboot-rockchip/Makefile

# 复制配置文件到uboot-rockchip
cp -a $GITHUB_WORKSPACE/configfiles/dts/rk3399/* package/boot/uboot-rockchip/src/arch/arm/dts/
cp -f $GITHUB_WORKSPACE/configfiles/uboot-rockchip/tvi3315a-rk3399_defconfig package/boot/uboot-rockchip/src/configs/
cp -f $GITHUB_WORKSPACE/configfiles/uboot-rockchip/rk3399-tvi3315a-u-boot.dtsi package/boot/uboot-rockchip/src/arch/arm/dts/

# 复制dts设备树文件到指定目录下
cp -a $GITHUB_WORKSPACE/configfiles/dts/rk3399/* target/linux/rockchip/files/arch/arm64/boot/dts/rockchip/
cp -f $GITHUB_WORKSPACE/configfiles/dts/rk3568/rk3566-roc-pc.dts target/linux/rockchip/dts/rk3568/

# 添加dtb补丁
cp -f $GITHUB_WORKSPACE/configfiles/patch/900-add-rk3399-tvi3315a-dtb-to-makefile.patch target/linux/rockchip/patches-6.6/

# 测试添加luci-app-turboacc
#curl -sSL https://raw.githubusercontent.com/chenmozhijin/turboacc/luci/add_turboacc.sh -o add_turboacc.sh && bash add_turboacc.sh --no-sfe

# 定时限速插件
#git clone --depth=1 https://github.com/sirpdboy/luci-app-eqosplus package/luci-app-eqosplus
