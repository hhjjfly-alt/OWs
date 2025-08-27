#!/bin/bash
set -e

#---------------------------------------------------
# 工具：只添加一次 feed（防重复）
#---------------------------------------------------
add_feed_once() {
    local name="$1"
    local url="$2"
    local file="feeds.conf.default"
    grep -qF "src-git $name " "$file" || echo "$url" >> "$file"
}

#---------------------------------------------------
# 1) 回滚/锁定 luci feed（Lean）
#---------------------------------------------------
sed -i '/^#src-git luci https:\/\/github.com\/coolsnowwolf\/luci$/s/^#//' feeds.conf.default
sed -i '/^src-git luci https:\/\/github.com\/coolsnowwolf\/luci\.git;openwrt-23\.05$/s/^/#/' feeds.conf.default

#---------------------------------------------------
# 2) 全局替换默认 LAN IP
#---------------------------------------------------
sed -i 's/192\.168\.1\.1/10.0.0.8/g' package/base-files/files/bin/config_generate

#---------------------------------------------------
# 3) 添加 feeds（仅当不存在时追加）
#---------------------------------------------------
add_feed_once "infinityfreedom"   "src-git infinityfreedom https://github.com/xiaoqingfengATGH/luci-theme-infinityfreedom.git"
add_feed_once "passwall_packages" "src-git passwall_packages https://github.com/xiaorouji/openwrt-passwall-packages.git;main"
add_feed_once "passwall_luci"     "src-git passwall_luci https://github.com/xiaorouji/openwrt-passwall.git;main"
add_feed_once "istore"            "src-git istore https://github.com/linkease/istore;main"

#---------------------------------------------------
# 4) 替换默认主题为 argon
#---------------------------------------------------
[[ -d package/lean/luci-theme-argon ]] && rm -rf package/lean/luci-theme-argon
git clone -b 18.06 --depth 1 https://github.com/jerrykuku/luci-theme-argon.git package/lean/luci-theme-argon

# 5)###### 更改大雕源码（可选）#######
sed -i 's/KERNEL_PATCHVER:=.*/KERNEL_PATCHVER:=6.12/' target/linux/x86/Makefile
#---------------------------------------------------
# 6) 结束提示
#---------------------------------------------------
echo "=== configure.sh 完成 ==="
