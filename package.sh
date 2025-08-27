#!/bin/bash
set -e

#---------------------------------------------------
# 工具：只添加一次 feed（如决定把 feed 写在 package.sh）
#---------------------------------------------------
add_feed_once() {
    local name="$1"
    local url="$2"
    local file="feeds.conf.default"
    grep -qF "src-git $name " "$file" || echo "$url" >> "$file"
}

#---------------------------------------------------
# 1) 第三方应用
#---------------------------------------------------
# git clone --depth 1 https://github.com/bigbugcc/OpenwrtApp         package/otherapp/OpenwrtApp
# git clone --depth 1 https://github.com/destan19/OpenAppFilter      package/otherapp/OpenAppFilter
# git clone --depth 1 https://github.com/zzsj0928/luci-app-pushbot   package/otherapp/luci-app-pushbot

#---------------------------------------------------
# 2) 主题
#---------------------------------------------------
git clone --depth 1 https://github.com/thinktip/luci-theme-neobird.git package/otherapp/luci-theme-neobird

#---------------------------------------------------
# 3) 其它独立包
#---------------------------------------------------
git clone --depth 1 https://github.com/KyleRicardo/MentoHUST-OpenWrt-ipk.git package/otherapp/mentohust
git clone https://github.com/gdy666/luci-app-lucky.git package/otherapp/lucky

#---------------------------------------------------
# 4) luci-app-dockerman（避免与 Lean 自带冲突）
#---------------------------------------------------
git clone --depth 1 https://github.com/lisaac/luci-app-dockerman package/otherapp/luci-app-dockerman

#---------------------------------------------------
# 5) 更新 SmartDNS 到最新版本（仅在此处保留）
#---------------------------------------------------
SMARTDNS_MK="feeds/packages/net/smartdns/Makefile"
[[ -f "$SMARTDNS_MK" ]] && {
    sed -i 's/^\(PKG_VERSION:=\).*/\11.2024.46/' "$SMARTDNS_MK"
    sed -i 's/^\(PKG_SOURCE_VERSION:=\).*/\1b525170bfd627607ee5ac81f97ae0f1f4f087d6b/' "$SMARTDNS_MK"
    sed -i '/^PKG_MIRROR_HASH/d' "$SMARTDNS_MK"
}

echo "=== package.sh 完成 ==="
