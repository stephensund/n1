#!/bin/bash
set -euo pipefail

# 1) 临时工作区
WORKDIR="$(pwd)"
TMPDIR="${WORKDIR}/clone"
mkdir -p "${TMPDIR}"

# 2) 拉取：Amlogic 面板（ophub） + Passwall（Openwrt-Passwall 组织）
git clone --depth=1 https://github.com/ophub/luci-app-amlogic             "${TMPDIR}/luci-app-amlogic"
git clone --depth=1 https://github.com/Openwrt-Passwall/openwrt-passwall  "${TMPDIR}/passwall_luci"

# 3) 防冲突清理（旧版/自带）
rm -rf feeds/luci/applications/luci-app-amlogic \
       feeds/luci/applications/luci-app-passwall \
       feeds/*/luci-app-dockerman package/*/luci-app-dockerman 2>/dev/null || true

# 4) 覆盖最新源码到 feeds 路径（仅 LuCI 前端）
cp -a "${TMPDIR}/luci-app-amlogic/luci-app-amlogic"     feeds/luci/applications/
cp -a "${TMPDIR}/passwall_luci/luci-app-passwall"       feeds/luci/applications/

# 5) 重新安装索引
./scripts/feeds install -a

# 6) 清理
rm -rf "${TMPDIR}"

echo "[diy.sh] Done: amlogic + passwall(frontend from Openwrt-Passwall) injected; dockerman removed."
