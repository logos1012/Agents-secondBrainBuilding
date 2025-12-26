#!/bin/bash

# Second Brain Building - Organizer Worker
# 백그라운드에서 노트 조직화 작업을 처리하는 워커

SESSION_PATH="$1"

if [ -z "$SESSION_PATH" ]; then
  echo "Error: SESSION_PATH is required"
  echo "Usage: $0 <session-path>"
  exit 1
fi

QUEUE_FILE="$SESSION_PATH/MOC/.pending-tasks.jsonl"
LOCK_FILE="$SESSION_PATH/MOC/.organizer.lock"
PROCESSED_FILE="$SESSION_PATH/MOC/.processed-tasks.log"

echo "========================================="
echo "🔄 Organizer Worker Started"
echo "========================================="
echo "Session: $SESSION_PATH"
echo "Queue: $QUEUE_FILE"
echo "Started at: $(date)"
echo "========================================="

# 종료 시그널 처리
trap "echo '🛑 Worker stopped'; rm -f '$LOCK_FILE'; exit 0" SIGTERM SIGINT

# 메인 루프
while true; do
  # 큐 파일 존재 확인
  if [ ! -f "$QUEUE_FILE" ]; then
    sleep 2
    continue
  fi

  # 큐가 비어있는지 확인
  if [ ! -s "$QUEUE_FILE" ]; then
    sleep 2
    continue
  fi

  # Lock 획득 (다중 워커 방지)
  if [ -f "$LOCK_FILE" ]; then
    sleep 1
    continue
  fi
  touch "$LOCK_FILE"

  # 첫 번째 미처리 작업 읽기
  TASK=$(head -n 1 "$QUEUE_FILE" 2>/dev/null)

  if [ -z "$TASK" ]; then
    rm -f "$LOCK_FILE"
    sleep 2
    continue
  fi

  # 작업 파싱
  NOTE_PATH=$(echo "$TASK" | jq -r '.note_path')
  TASK_ID=$(echo "$TASK" | jq -r '.task_id')
  NOTE_TITLE=$(echo "$TASK" | jq -r '.note_title // "Unknown"')

  echo ""
  echo "📝 Processing task: $TASK_ID"
  echo "   Note: $NOTE_TITLE"
  echo "   Path: $NOTE_PATH"
  echo "   Time: $(date '+%H:%M:%S')"

  # 노트 파일 존재 확인
  if [ ! -f "$NOTE_PATH" ]; then
    echo "⚠️  Note file not found, skipping: $NOTE_PATH"
    sed -i '' '1d' "$QUEUE_FILE"
    rm -f "$LOCK_FILE"
    continue
  fi

  # 조직화 작업 실행 (별도 Claude Code 호출)
  echo "   → Running smart-organizer..."
  echo "   → Running moc-storyteller..."
  echo "   → Running link-weaver..."

  # 임시 프롬프트 파일 생성
  TEMP_PROMPT=$(mktemp)
  cat > "$TEMP_PROMPT" <<EOF
Execute the following agents in sequence for the note:

Note path: $NOTE_PATH
Session path: $SESSION_PATH

1. Use smart-organizer to categorize the note and move it to appropriate folder
2. Use moc-storyteller to update the MOC index
3. Use link-weaver to create bidirectional links with related notes

Work silently without asking for confirmation.
Report only success or failure.
EOF

  # Claude Code 실행 (출력 캡처)
  if claude-code < "$TEMP_PROMPT" > "$SESSION_PATH/MOC/.worker-output.log" 2>&1; then
    echo "✅ Completed: $TASK_ID"
    echo "$TASK_ID - $(date) - SUCCESS - $NOTE_TITLE" >> "$PROCESSED_FILE"
  else
    echo "❌ Failed: $TASK_ID"
    echo "$TASK_ID - $(date) - FAILED - $NOTE_TITLE" >> "$PROCESSED_FILE"
  fi

  # 임시 파일 삭제
  rm -f "$TEMP_PROMPT"

  # 작업 완료 처리 (큐에서 제거)
  sed -i '' '1d' "$QUEUE_FILE"

  # Lock 해제
  rm -f "$LOCK_FILE"

  # 다음 작업 전 잠시 대기
  sleep 1
done
