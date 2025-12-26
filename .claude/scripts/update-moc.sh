#!/bin/bash

# MOC (Map of Contents) 자동 생성 스크립트
# knowledge/prompts/ 하위의 모든 프롬프트를 스캔하여 MOC 파일 생성

set -e  # 에러 발생 시 즉시 종료

# 색상 정의
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'  # No Color

# 경로 설정
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
PROMPTS_DIR="$PROJECT_ROOT/knowledge/prompts"
MOC_FILE="$PROMPTS_DIR/MOC-prompts.md"
TEMP_DIR="/tmp/prompt-moc-$$"

echo -e "${BLUE}📚 프롬프트 MOC 업데이트 시작...${NC}"

# 임시 디렉토리 생성
mkdir -p "$TEMP_DIR"

# cleanup 함수
cleanup() {
    rm -rf "$TEMP_DIR"
}
trap cleanup EXIT

# 프롬프트 디렉토리 확인
if [ ! -d "$PROMPTS_DIR" ]; then
    echo -e "${YELLOW}⚠️  프롬프트 디렉토리가 없습니다: $PROMPTS_DIR${NC}"
    mkdir -p "$PROMPTS_DIR"/{coding,writing,analysis,planning,automation,learning}
    echo -e "${GREEN}✅ 프롬프트 디렉토리 생성 완료${NC}"
fi

# 프롬프트 파일 찾기 (MOC 파일 제외)
find "$PROMPTS_DIR" -type f -name "*.md" ! -name "MOC-*.md" > "$TEMP_DIR/all_prompts.txt"
TOTAL_PROMPTS=$(wc -l < "$TEMP_DIR/all_prompts.txt" | tr -d ' ')

echo -e "${BLUE}📊 발견된 프롬프트: $TOTAL_PROMPTS 개${NC}"

if [ "$TOTAL_PROMPTS" -eq 0 ]; then
    echo -e "${YELLOW}⚠️  프롬프트가 없습니다. 빈 MOC를 생성합니다.${NC}"
fi

# YAML 프론트매터 파싱 함수
parse_yaml() {
    local file="$1"
    local field="$2"

    # YAML 프론트매터에서 필드 추출
    awk -v field="$field" '
        BEGIN { in_yaml=0; in_tags=0; }
        /^---$/ {
            if (in_yaml==0) in_yaml=1;
            else if (in_yaml==1) exit;
            next;
        }
        in_yaml==1 {
            if ($1 == field":") {
                sub(/^[^:]+: */, "");
                print;
            } else if (field == "tags" && $1 == "tags:") {
                in_tags=1;
                next;
            } else if (in_tags==1 && /^  - /) {
                sub(/^  - /, "");
                print;
            } else if (in_tags==1 && /^[^ ]/) {
                in_tags=0;
            }
        }
    ' "$file"
}

# 카테고리별 프롬프트 수집
CATEGORIES=("coding" "writing" "analysis" "planning" "automation" "learning")

# 카테고리별 임시 파일 생성
for category in "${CATEGORIES[@]}"; do
    > "$TEMP_DIR/category_$category.txt"
done

# 태그 수집용
> "$TEMP_DIR/all_tags.txt"

# 각 프롬프트 파일 처리
while IFS= read -r file; do
    if [ ! -f "$file" ]; then
        continue
    fi

    # 메타데이터 추출
    title=$(parse_yaml "$file" "title" | head -1)
    description=$(parse_yaml "$file" "description" | head -1)
    created=$(parse_yaml "$file" "created" | head -1)
    category=$(parse_yaml "$file" "category" | sed 's|prompts/||')

    # 태그 추출
    tags=$(parse_yaml "$file" "tags" | tr '\n' ',' | sed 's/,$//')

    # 태그를 파일에 저장 (통계용)
    if [ -n "$tags" ]; then
        echo "$tags" | tr ',' '\n' >> "$TEMP_DIR/all_tags.txt"
    fi

    # 파일명 추출 (확장자 제외)
    filename=$(basename "$file" .md)

    # 기본값 설정
    [ -z "$title" ] && title="$filename"
    [ -z "$description" ] && description="No description"
    [ -z "$created" ] && created="Unknown"
    [ -z "$category" ] && category="uncategorized"

    # 카테고리별 파일에 추가
    entry="- **[[$filename]]** - $description ($created)"
    echo "$entry" >> "$TEMP_DIR/category_$category.txt"

done < "$TEMP_DIR/all_prompts.txt"

# 태그 통계 생성 (TOP 10)
if [ -s "$TEMP_DIR/all_tags.txt" ]; then
    sort "$TEMP_DIR/all_tags.txt" | uniq -c | sort -rn | head -10 > "$TEMP_DIR/top_tags.txt"
fi

# 현재 날짜
CURRENT_DATE=$(date +%Y-%m-%d)

# MOC 파일 생성
cat > "$MOC_FILE" <<EOF
---
title: 프롬프트 라이브러리 목차
description: 저장된 모든 프롬프트의 카테고리별 인덱스
created: $CURRENT_DATE
updated: $CURRENT_DATE
tags: [moc, index, prompts]
category: prompts
---

# 프롬프트 라이브러리

> 총 **${TOTAL_PROMPTS}개**의 프롬프트 저장됨 | 마지막 업데이트: $CURRENT_DATE

## 📊 통계

EOF

# 카테고리별 통계 추가
for category in "${CATEGORIES[@]}"; do
    count=$(wc -l < "$TEMP_DIR/category_$category.txt" | tr -d ' ')
    case $category in
        coding) emoji="🔧"; cap_name="Coding" ;;
        writing) emoji="✍️"; cap_name="Writing" ;;
        analysis) emoji="📈"; cap_name="Analysis" ;;
        planning) emoji="📋"; cap_name="Planning" ;;
        automation) emoji="⚙️"; cap_name="Automation" ;;
        learning) emoji="📚"; cap_name="Learning" ;;
        *) emoji="📁"; cap_name="$(echo $category | sed 's/\b\(.\)/\u\1/')" ;;
    esac
    echo "- $emoji **${cap_name}**: ${count}개" >> "$MOC_FILE"
done

cat >> "$MOC_FILE" <<EOF

---

EOF

# 각 카테고리별 프롬프트 목록 추가
for category in "${CATEGORIES[@]}"; do
    if [ -s "$TEMP_DIR/category_$category.txt" ]; then
        case $category in
            coding) emoji="🔧"; cap_name="Coding"; desc="코드 작성, 디버깅, 리팩토링, API 구현" ;;
            writing) emoji="✍️"; cap_name="Writing"; desc="문서 작성, 블로그, 기술 문서, 설명서" ;;
            analysis) emoji="📈"; cap_name="Analysis"; desc="데이터 분석, 코드 리뷰, 아키텍처 분석" ;;
            planning) emoji="📋"; cap_name="Planning"; desc="프로젝트 계획, 아키텍처 설계, 워크플로우 설계" ;;
            automation) emoji="⚙️"; cap_name="Automation"; desc="스크립트 작성, CI/CD, 자동화 워크플로우" ;;
            learning) emoji="📚"; cap_name="Learning"; desc="개념 설명, 튜토리얼, 학습 자료" ;;
            *) emoji="📁"; cap_name="$(echo $category | sed 's/\b\(.\)/\u\1/')"; desc="" ;;
        esac

        cat >> "$MOC_FILE" <<EOF
## $emoji $cap_name

> $desc

EOF
        cat "$TEMP_DIR/category_$category.txt" >> "$MOC_FILE"
        cat >> "$MOC_FILE" <<EOF

---

EOF
    fi
done

# 인기 태그 추가
if [ -s "$TEMP_DIR/top_tags.txt" ]; then
    cat >> "$MOC_FILE" <<EOF
## 🏷️ 인기 태그 (TOP 10)

EOF

    while IFS= read -r line; do
        count=$(echo "$line" | awk '{print $1}')
        tag=$(echo "$line" | awk '{$1=""; print $0}' | xargs)
        echo "- \`$tag\` ($count개)" >> "$MOC_FILE"
    done < "$TEMP_DIR/top_tags.txt"

    cat >> "$MOC_FILE" <<EOF

---

EOF
fi

# 검색 가이드 추가
cat >> "$MOC_FILE" <<EOF
## 🔍 검색 가이드

\`\`\`bash
# 키워드로 검색
/find-prompt <keyword>

# 카테고리 보기
/find-prompt --category <category>

# 태그로 필터
/find-prompt --tag <tag>

# 최근 프롬프트
/find-prompt --recent <N>

# 모든 프롬프트
/find-prompt --all
\`\`\`

---

## 관련 도구

- \`/save-prompt\` - 새 프롬프트 저장
- \`/find-prompt\` - 프롬프트 검색
- \`/load-prompt\` - 프롬프트 불러오기
- \`.claude/scripts/update-moc.sh\` - MOC 수동 업데이트

---

_이 파일은 자동 생성됩니다. 직접 편집하지 마세요._
EOF

echo -e "${GREEN}✅ MOC 파일 생성 완료: $MOC_FILE${NC}"
echo -e "${BLUE}📊 통계:${NC}"
echo -e "  - 총 프롬프트: $TOTAL_PROMPTS 개"

for category in "${CATEGORIES[@]}"; do
    count=$(wc -l < "$TEMP_DIR/category_$category.txt" | tr -d ' ')
    if [ "$count" -gt 0 ]; then
        echo -e "  - ${category}: $count 개"
    fi
done

if [ -s "$TEMP_DIR/top_tags.txt" ]; then
    top_tag=$(head -1 "$TEMP_DIR/top_tags.txt" | awk '{$1=""; print $0}' | xargs)
    top_count=$(head -1 "$TEMP_DIR/top_tags.txt" | awk '{print $1}')
    echo -e "  - 인기 태그: $top_tag ($top_count 개)"
fi

echo -e "${GREEN}✨ MOC 업데이트 완료!${NC}"
