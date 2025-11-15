#!/bin/sh
# 同时启动前端和后端（分离运行）

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$PROJECT_ROOT"

echo "🚀 启动 RustFS（前端 + 后端分离模式）"
echo ""

# 启动后端（后台运行）
echo "📦 启动后端..."
"$SCRIPT_DIR/start-backend.sh" &
BACKEND_PID=$!

# 等待后端启动
sleep 3

# 启动前端（前台运行，方便查看日志）
echo "📦 启动前端..."
"$SCRIPT_DIR/start-frontend.sh" &
FRONTEND_PID=$!

# 捕获退出信号，清理进程
trap "echo '🛑 停止服务...'; kill $BACKEND_PID $FRONTEND_PID 2>/dev/null; exit" INT TERM

# 等待进程
wait

