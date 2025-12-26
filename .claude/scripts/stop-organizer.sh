#!/bin/bash

# Second Brain Building - Stop Organizer Worker
# 백그라운드 워커를 중지하는 스크립트

SESSION_PATH="$1"

if [ -z "$SESSION_PATH" ]; then
  echo "❌ Error: SESSION_PATH is required"
  echo "Usage: $0 <session-path>"
  exit 1
fi

# 절대 경로로 변환
SESSION_PATH=$(cd "$SESSION_PATH" && pwd)

PID_FILE="$SESSION_PATH/MOC/.organizer.pid"
LOCK_FILE="$SESSION_PATH/MOC/.organizer.lock"

# PID 파일 확인
if [ ! -f "$PID_FILE" ]; then
  echo "❌ No organizer running (PID file not found)"
  exit 1
fi

PID=$(cat "$PID_FILE")

# 프로세스 확인
if ! ps -p "$PID" > /dev/null 2>&1; then
  echo "⚠️  Process not running (PID: $PID)"
  echo "   Cleaning up stale files..."
  rm -f "$PID_FILE" "$LOCK_FILE"
  exit 0
fi

echo "🛑 Stopping Organizer Worker..."
echo "   PID: $PID"

# SIGTERM 전송 (graceful shutdown)
kill "$PID" 2>/dev/null

# 최대 5초 대기
for i in {1..5}; do
  if ! ps -p "$PID" > /dev/null 2>&1; then
    echo "✅ Worker stopped successfully"
    rm -f "$PID_FILE" "$LOCK_FILE"
    exit 0
  fi
  sleep 1
done

# 강제 종료
echo "⚠️  Forcing shutdown..."
kill -9 "$PID" 2>/dev/null
rm -f "$PID_FILE" "$LOCK_FILE"
echo "✅ Worker forcefully stopped"
