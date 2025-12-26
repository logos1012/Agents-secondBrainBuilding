#!/bin/bash

# Second Brain Building - Start Organizer Worker
# 백그라운드 워커를 시작하는 스크립트

SESSION_PATH="$1"

if [ -z "$SESSION_PATH" ]; then
  echo "❌ Error: SESSION_PATH is required"
  echo "Usage: $0 <session-path>"
  exit 1
fi

# 절대 경로로 변환
SESSION_PATH=$(cd "$SESSION_PATH" && pwd)

# 필요한 디렉토리 생성
mkdir -p "$SESSION_PATH/MOC"

PID_FILE="$SESSION_PATH/MOC/.organizer.pid"
LOG_FILE="$SESSION_PATH/MOC/.organizer.log"

# 이미 실행 중인지 확인
if [ -f "$PID_FILE" ]; then
  PID=$(cat "$PID_FILE")
  if ps -p "$PID" > /dev/null 2>&1; then
    echo "✅ Organizer already running (PID: $PID)"
    echo "📋 Log: $LOG_FILE"
    exit 0
  else
    echo "⚠️  Stale PID file found, removing..."
    rm -f "$PID_FILE"
  fi
fi

# 스크립트 경로 찾기
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
WORKER_SCRIPT="$SCRIPT_DIR/organizer-worker.sh"

if [ ! -f "$WORKER_SCRIPT" ]; then
  echo "❌ Error: Worker script not found: $WORKER_SCRIPT"
  exit 1
fi

# 실행 권한 확인
chmod +x "$WORKER_SCRIPT"

echo "🚀 Starting Organizer Worker..."
echo "   Session: $SESSION_PATH"

# 백그라운드로 워커 실행
nohup "$WORKER_SCRIPT" "$SESSION_PATH" > "$LOG_FILE" 2>&1 &
WORKER_PID=$!

# PID 저장
echo "$WORKER_PID" > "$PID_FILE"

# 워커가 정상 시작되었는지 확인 (1초 대기)
sleep 1
if ps -p "$WORKER_PID" > /dev/null 2>&1; then
  echo "✅ Organizer started successfully"
  echo "   PID: $WORKER_PID"
  echo "   Log: $LOG_FILE"
  echo ""
  echo "💡 Tip: Use 'tail -f $LOG_FILE' to monitor worker"
else
  echo "❌ Failed to start worker"
  rm -f "$PID_FILE"
  exit 1
fi
