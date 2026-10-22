#!/usr/bin/env bash
# Supermodel-NX 1.4.0 带即时存档补丁的 Switch 编译脚本
# 前置：已安装 devkitPro (dkp-pacman -S switch-dev switch-sdl2 switch-mesa switch-zlib)
# 用法：./build_switch.sh

set -e
if [ -z "$DEVKITPRO" ]; then
  echo "错误：请先设置 DEVKITPRO 环境变量"
  echo "  export DEVKITPRO=/opt/devkitpro"
  exit 1
fi

cd "$(dirname "$0")"

echo ">>> 应用即时存档补丁（JIT 缓存一致性修复）..."
if patch -p1 --dry-run < savestate-fix.patch > /dev/null 2>&1; then
  patch -p1 < savestate-fix.patch
  echo "    补丁已应用"
else
  echo "    （补丁已应用过或基线不匹配，跳过）"
fi

echo ">>> 开始编译 Switch 版（多核）..."
make -f Makefile.switch -j"$(nproc)"

echo
echo ">>> 完成：输出位于 build/switch/supermodel.nro"
echo "    将其复制到 sdmc:/switch/supermodel/supermodel.nro"
