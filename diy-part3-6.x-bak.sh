##调调整文件说明

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
cp -f $GITHUB_WORKSPACE/configfiles/uboot-rockchip/rk3399-tvi3315a-u-boot.dtsi package/boot/uboot-rockchip/src/arch/arm/dts/
cp -f $GITHUB_WORKSPACE/configfiles/uboot-rockchip/tvi3315a-rk3399_defconfig package/boot/uboot-rockchip/src/configs/

# 复制dts设备树文件到指定目录下
cp -a $GITHUB_WORKSPACE/configfiles/dts/rk3399/* target/linux/rockchip/files/arch/arm64/boot/dts/rockchip/
cp -f $GITHUB_WORKSPACE/configfiles/dts/rk3568/rk3566-roc-pc.dts target/linux/rockchip/dts/rk3568/

# 添加dtb补丁
cp -f $GITHUB_WORKSPACE/configfiles/patch/900-add-rk3399-tvi3315a-dtb-to-makefile.patch target/linux/rockchip/patches-6.6/
