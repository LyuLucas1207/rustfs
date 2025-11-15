#!/bin/sh
# 启动 RustFS 后端（不启用嵌入的 Console）

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$PROJECT_ROOT"

# 加载 Rust 环境
if [ -f "../../use-rust1.91.sh" ]; then
    source ../../use-rust1.91.sh
fi

# 设置环境变量
export RUSTFS_VOLUMES="${RUSTFS_VOLUMES:-./deploy/data/dev{1...8}}"
export RUSTFS_ADDRESS="${RUSTFS_ADDRESS:-:9000}"
# 禁用嵌入的 Console（前端独立运行）
export RUSTFS_CONSOLE_ENABLE=false
export RUSTFS_CONSOLE_ADDRESS=""

# 日志配置
if [ -z "$RUST_LOG" ]; then
    export RUST_LOG="rustfs=info"
fi

echo "🚀 启动 RustFS 后端..."
echo "   地址: ${RUSTFS_ADDRESS}"
echo "   Console: 已禁用（前端独立运行）"
echo ""

# 运行后端
cargo run --bin rustfs

