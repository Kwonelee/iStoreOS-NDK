#!/bin/bash

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

# 复制dts到target/linux/rockchip/dts/rk3568
cp -f $GITHUB_WORKSPACE/configfiles/dts/rk3568/rk3566-jp-tvbox.dts target/linux/rockchip/dts/rk3568/
# ================================================================
# RK35xx示例结束
# ================================================================

mkdir -p files/etc/config
wget -qO- https://raw.githubusercontent.com/Kwonelee/Kwonelee/refs/heads/main/rule/openclash > files/etc/config/openclash
#wget -qO- https://raw.githubusercontent.com/sos801107/TL-XDR608X/refs/heads/main/etc/mosdns > files/etc/config/mosdns
#wget -qO- https://raw.githubusercontent.com/sos801107/TL-XDR608X/refs/heads/main/etc/smartdns > files/etc/config/smartdns

mkdir -p files/etc
wget -qO- https://raw.githubusercontent.com/sos801107/TL-XDR608X/refs/heads/main/etc/opkg.conf > files/etc/opkg.conf
#mkdir -p files/etc/opkg
#wget -qO- https://raw.githubusercontent.com/sos801107/TL-XDR608X/refs/heads/main/etc/x86/distfeeds.conf > files/etc/opkg/distfeeds.conf
mkdir -p files/root
wget -qO- https://raw.githubusercontent.com/sos801107/TL-XDR608X/refs/heads/main/etc/.profile > files/root/.profile

# 更改时间戳
rm -rf scripts/get_source_date_epoch.sh
mkdir -p scripts
wget -qO- https://raw.githubusercontent.com/Jaykwok2999/istoreos-actions/refs/heads/main/patch/get_source_date_epoch.sh > scripts/get_source_date_epoch.sh
chmod +x scripts/get_source_date_epoch.sh

#修改默认IP地址
sed -i "s/192\.168\.[0-9]*\.[0-9]*/192.168.5.89/g" ./package/base-files/files/bin/config_generate
#修改默认主机名
sed -i "s/hostname='.*'/hostname='iStoreOS'/g" ./package/base-files/files/bin/config_generate
#修改默认时区
sed -i "s/timezone='.*'/timezone='CST-8'/g" ./package/base-files/files/bin/config_generate
sed -i "/timezone='.*'/a\\\t\t\set system.@system[-1].zonename='Asia/Shanghai'" ./package/base-files/files/bin/config_generate
# TTYD
sed -i 's/services/system/g' feeds/luci/applications/luci-app-ttyd/root/usr/share/luci/menu.d/luci-app-ttyd.json

#取消bootstrap为默认主题
sed -i '/set luci.main.mediaurlbase=\/luci-static\/bootstrap/d' feeds/luci/themes/luci-theme-bootstrap/root/etc/uci-defaults/30_luci-theme-bootstrap
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci-nginx/Makefile

#加入作者信息
#sed -i "s/DISTRIB_REVISION='*.*'/DISTRIB_REVISION=' by kwonelee'/g" package/base-files/files/etc/openwrt_release

# 移除要替换的包
rm -rf feeds/packages/net/{xray-core,v2ray-core,v2ray-geodata,sing-box,adguardhome,mosdns,v2ray-geodata,v2ray-geoip,chinadns-ng,dns2socks,dns2tcp,microsocks,alist}
rm -rf feeds/packages/utils/v2dat
rm -rf feeds/third_party/{luci-app-LingTiGameAcc,luci-app-smartdns,smartdns}
rm -rf feeds/small/{luci-app-openclash,sing-box,luci-app-passwall,shadowsocksr-libev,shadowsocks-rust,luci-app-ssr-plus,luci-i18n-ssr-plus-zh-cn,luci-app-ssr-plus,luci-i18n-ssr-plus-zh-cn,luci-app-wol,luci-app-bypass,luci-app-argon-config,luci-theme-argon}
rm -rf feeds/luci/applications/{luci-app-tailscale,luci-app-turboacc,luci-app-alist,shadowsocksr-libev,shadowsocks-rust,luci-app-ssr-plus,luci-i18n-ssr-plus-zh-cn,luci-app-ssr-plus,luci-i18n-ssr-plus-zh-cn,luci-app-wol,luci-app-bypass,luci-app-argon-config,luci-theme-argon}
rm -rf feeds/luci/packages/net/{shadowsocksr-libev-ssr-check,shadowsocksr-libev-ssr-local,shadowsocksr-libev-ssr-redir,shadowsocksr-libev-ssr-server}
rm -rf feeds/kenzo/luci-app-adguardhome
# istoreos-theme
rm -rf feeds/kenzo/{luci-app-argon-config,luci-theme-argon}
rm -rf feeds/third/{luci-app-argon-config,luci-theme-argon}
rm -rf feeds/luci/themes/luci-theme-argon
rm -rf feeds/luci/applications/luci-app-argon-config
rm -rf packages/istoreos-files

# Git稀疏克隆，只克隆指定目录到本地
function git_sparse_clone() {
  branch="$1" repourl="$2" && shift 2
  git clone --depth=1 -b $branch --single-branch --filter=blob:none --sparse $repourl
  repodir=$(echo $repourl | awk -F '/' '{print $(NF)}')
  cd $repodir && git sparse-checkout set $@
  mv -f $@ ../package
  cd .. && rm -rf $repodir
}

function merge_package() {
    # 参数1是分支名,参数2是库地址,参数3是所有文件下载到指定路径。
    # 同一个仓库下载多个文件夹直接在后面跟文件名或路径，空格分开。
    if [[ $# -lt 3 ]]; then
        echo "Syntax error: [$#] [$*]" >&2
        return 1
    fi
    trap 'rm -rf "$tmpdir"' EXIT
    branch="$1" curl="$2" target_dir="$3" && shift 3
    rootdir="$PWD"
    localdir="$target_dir"
    [ -d "$localdir" ] || mkdir -p "$localdir"
    tmpdir="$(mktemp -d)" || exit 1
    git clone -b "$branch" --depth 1 --filter=blob:none --sparse "$curl" "$tmpdir"
    cd "$tmpdir"
    git sparse-checkout init --cone
    git sparse-checkout set "$@"
    # 使用循环逐个移动文件夹
    for folder in "$@"; do
        mv -f "$folder" "$rootdir/$localdir"
    done
    cd "$rootdir"
}


#git_sparse_clone openwrt-24.10 https://github.com/sbwml/luci-theme-argon luci-theme-argon
#git_sparse_clone openwrt-24.10 https://github.com/sbwml/luci-theme-argon luci-app-argon-config

#git_sparse_clone main https://github.com/Jaykwok2999/istoreos-theme luci-theme-argon
#git_sparse_clone main https://github.com/Jaykwok2999/istoreos-theme luci-app-argon-config

git_sparse_clone main https://github.com/xiaorouji/openwrt-passwall luci-app-passwall
git_sparse_clone luci https://github.com/chenmozhijin/turboacc luci-app-turboacc
git_sparse_clone main https://github.com/kiddin9/kwrt-packages luci-app-mosdns
git_sparse_clone main https://github.com/kiddin9/kwrt-packages mosdns
git_sparse_clone main https://github.com/kiddin9/kwrt-packages luci-app-tailscale
git_sparse_clone main https://github.com/kiddin9/kwrt-packages tailscale
git_sparse_clone main https://github.com/kiddin9/kwrt-packages luci-app-upnp
git_sparse_clone main https://github.com/kiddin9/kwrt-packages miniupnpd

git_sparse_clone master https://github.com/vernesong/OpenClash luci-app-openclash

#git_sparse_clone main https://github.com/sos801107/packages sing-box
#git_sparse_clone main https://github.com/sos801107/packages istoreos-files


#在线OTA
rm -rf package/diy/luci-app-ota
git_sparse_clone main https://github.com/sos801107/istoreos-ota luci-app-ota
git_sparse_clone main https://github.com/sos801107/istoreos-ota fw_download_tool

git clone https://github.com/destan19/OpenAppFilter.git package/OpenAppFilter

# golong依赖
rm -rf feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 25.x feeds/packages/lang/golang

# UPnP
rm -rf feeds/{packages/net/miniupnpd,luci/applications/luci-app-upnp}
git clone https://git.kejizero.online/zhao/miniupnpd feeds/packages/net/miniupnpd -b v2.3.9
git clone https://git.kejizero.online/zhao/luci-app-upnp feeds/luci/applications/luci-app-upnp -b openwrt-24.10

# 必要的补丁
pushd feeds/luci
   curl -s https://raw.githubusercontent.com/oppen321/path/refs/heads/main/Firewall/0001-luci-mod-status-firewall-disable-legacy-firewall-rul.patch | patch -p1
popd

pushd
   curl -sSL https://raw.githubusercontent.com/Jaykwok2999/turboacc/luci/add_turboacc.sh -o add_turboacc.sh && bash add_turboacc.sh
popd


./scripts/feeds update -a
./scripts/feeds install -a
