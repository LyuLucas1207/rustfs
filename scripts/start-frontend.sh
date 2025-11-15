#!/bin/sh
# 启动 RustFS Console 前端

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
CONSOLE_DIR="$PROJECT_ROOT/../rustfsconsole"

if [ ! -d "$CONSOLE_DIR" ]; then
    echo "❌ 错误: Console 项目不存在: $CONSOLE_DIR"
    exit 1
fi

cd "$CONSOLE_DIR"

# 加载 Node.js 环境
if [ -f "../../FrontEnd/use-node24.sh" ]; then
    source ../../FrontEnd/use-node24.sh
fi

# 检查 pnpm
if ! command -v pnpm >/dev/null 2>&1; then
    echo "📦 安装 pnpm..."
    npm install -g pnpm@10.19.0
fi

# 安装依赖（如果需要）
if [ ! -d "node_modules" ]; then
    echo "📦 安装依赖..."
    pnpm install
fi

echo "🚀 启动 RustFS Console 前端..."
echo "   地址: http://0.0.0.0:3000"
echo ""

# 运行前端开发服务器
pnpm dev

