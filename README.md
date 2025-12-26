# Claude Code Multi-Agent Automation System

**Claude Code를 위한 포괄적인 멀티 에이전트 자동화 시스템**

이 프로젝트는 학습, 지식 관리, Agent 생성, 프롬프트 관리를 위한 4개의 통합 시스템을 제공합니다. 각 시스템은 전문화된 SubAgent들로 구성되어 복잡한 작업을 자동화합니다.

---

## 목차

- [개요](#개요)
- [시스템 구성](#시스템-구성)
  - [1. Second Brain Building](#1-second-brain-building)
  - [2. Agent Creator](#2-agent-creator)
  - [3. Knowledge Management](#3-knowledge-management)
  - [4. Prompts Management](#4-prompts-management)
- [설치 및 설정](#설치-및-설정)
- [빠른 시작](#빠른-시작)
- [시스템별 사용법](#시스템별-사용법)
- [핵심 기능](#핵심-기능)
- [프로젝트 구조](#프로젝트-구조)
- [성능 최적화](#성능-최적화)
- [문제 해결](#문제-해결)
- [기여](#기여)
- [라이선스](#라이선스)

---

## 개요

### 주요 특징

- **🤖 멀티 에이전트 아키텍처**: 17개의 전문화된 SubAgent가 협력하여 작업 수행
- **📚 대화식 학습 시스템**: 질문-답변 형태로 점진적 지식 구축
- **🔗 링크 인덱스 최적화**: 97% 토큰 절감 (100K → 3K)
- **🏗️ Agent 자동 생성**: 요구사항만으로 완전한 Agent 시스템 생성
- **📝 지식 자동화**: 대화를 Obsidian 호환 노트로 변환
- **💾 프롬프트 관리**: 재사용 가능한 프롬프트 라이브러리 구축

### 기술 스택

- **플랫폼**: Claude Code v2.0+
- **도구**: Task (SubAgent 조율), Bash, Read, Write, Edit, Glob, Grep
- **통합**: Obsidian, docx-js, pandoc, Node.js
- **포맷**: Markdown, YAML, JSON, DOCX

---

## 시스템 구성

### 1. Second Brain Building

**대화식 Q&A 학습 및 지식 체계 구축 시스템**

#### 개요
질문-답변 형태의 반복적 대화를 통해 점진적으로 지식 체계를 구축합니다.

#### SubAgents (7개)
1. **session-manager** - 학습 세션 초기화 및 복구
2. **web-researcher** - 웹 검색 및 자료 수집
3. **note-enricher** - 풍부한 노트 생성
4. **smart-organizer** - 자동 카테고리 분류
5. **moc-storyteller** - MOC 스토리텔링 업데이트
6. **link-weaver** - 양방향 링크 생성
7. **report-generator** - DOCX 보고서 생성

#### 주요 기능
- **대화식 학습**: 질문 → 답변 → 정리 → 다음 질문
- **링크 인덱스**: `link-index.json`을 통한 97% 토큰 절감
- **Description 기반 매칭**: 전체 파일 읽지 않고 내용 파악
- **docx-js 보고서**: 전문적인 문서 생성

#### 사용법
```bash
# 학습 세션 시작
/second-brain-building "웹 크롤러 백엔드 개발을 공부하고 싶어"

# 질문하기
/second-brain-building "웹 크롤러란 뭐야?"

# 보고서 생성
/second-brain-building "보고서"
```

#### 출력 구조
```
YYYYMMDD_도메인명/
├── MOC/
│   ├── 00_INDEX.md           # 학습 가이드
│   └── link-index.json       # 링크 최적화 인덱스
└── 학습내용/
    ├── 개념/
    ├── 실습/
    └── 도구/
```

---

### 2. Agent Creator

**요구사항 기반 Agent 시스템 자동 생성**

#### 개요
사용자 요구사항을 분석하여 완전한 Agent 시스템(.md 파일)을 자동으로 생성합니다.

#### SubAgents (4개)
1. **requirements-analyzer** - 요구사항 분석 및 SubAgent 식별
2. **code-generator** - Agent 및 SubAgent 파일 생성
3. **validator** - 생성된 파일 검증
4. **report-generator** - 최종 리포트 생성

#### 주요 기능
- **자동 분석**: 요구사항에서 필요한 SubAgent 추출
- **파일 생성**: `.claude/commands/` 및 `.claude/agents/` 파일 자동 생성
- **검증**: YAML 문법, 워크플로우, 도구 사용 검증
- **리포트**: 사용자 친화적 최종 리포트

#### 사용법
```bash
# Agent 생성
/create-agent "웹사이트를 크롤링하고 내용을 요약해줘"

# 복잡한 시스템 생성
/create-agent "블로그 포스트 자동 작성 시스템: 주제 조사, 개요 작성, 내용 작성, SEO 최적화"
```

#### 워크플로우
```
사용자 요구사항
    ↓
requirements-analyzer → code-generator → validator → report-generator
    ↓
생성된 Agent 파일 (.claude/commands/*.md, .claude/agents/*.md)
```

---

### 3. Knowledge Management

**대화를 Obsidian 노트로 변환하는 지식 관리 시스템**

#### 개요
사용자의 대화 내용을 구조화된 Obsidian 노트로 변환하고 기존 지식 네트워크에 자동 연결합니다.

#### SubAgents (3개)
1. **knowledge-analyzer** - 지식 구조 분석 및 분류
2. **note-writer** - Obsidian 노트 생성
3. **knowledge-linker** - MOC 업데이트 및 양방향 링크

#### 주요 기능
- **대화 요약**: 토큰 절약을 위한 핵심 추출
- **자동 분류**: 카테고리 및 태그 자동 생성
- **양방향 링크**: Obsidian wikilink 형식 (`[[note-name]]`)
- **MOC 업데이트**: Map of Contents 자동 관리

#### 사용법
```bash
# 대화 내용 저장
/km "이거 정리해서 md 파일로 생성해줘"

# 노트 생성
/km "방금 대화 내용 저장해줘"
```

#### YAML Frontmatter 형식
```yaml
---
title: 노트 제목
description: 노트 설명
created: 2025-12-26
updated: 2025-12-26
tags: [tag1, tag2, tag3]
category: programming/nodejs
related:
  - "[[note-name-1]]"
  - "[[note-name-2]]"
---
```

---

### 4. Prompts Management

**재사용 가능한 프롬프트 라이브러리 구축**

#### 개요
프롬프트를 체계적으로 저장하고 검색하여 재사용 가능한 프롬프트 라이브러리를 구축합니다.

#### SubAgents (2개)
1. **prompt-saver** - 프롬프트 저장 및 메타데이터 생성
2. **prompt-finder** - 키워드, 카테고리, 태그 기반 검색

#### 주요 기능
- **자동 추출**: 대화에서 프롬프트 자동 추출
- **메타데이터**: 카테고리, 태그, 설명 자동 생성
- **검색**: 키워드, 태그, 카테고리로 빠른 검색
- **MOC 통합**: 프롬프트 목차 자동 업데이트

#### 사용법
```bash
# 프롬프트 저장
/save-prompt "Web Scraper 가이드" --category coding --tags web-scraping,puppeteer

# 프롬프트 검색
/find-prompt "web scraping"
/find-prompt --category coding --tags nodejs
```

#### 저장 위치
```
knowledge/prompts/
├── coding/
├── writing/
├── analysis/
└── automation/
```

---

## 설치 및 설정

### 필수 요구사항
- **Claude Code**: v2.0.19 이상
- **파일 쓰기 권한**: 현재 디렉토리

### 선택 사항 (전체 기능 사용 시)

#### 웹 리서치용
```bash
curl --version  # 또는 wget
```

#### 보고서 생성용
```bash
# docx-js 방식 (권장)
npm install -g docx

# Fallback 방식
brew install pandoc  # macOS
apt install pandoc   # Ubuntu
```

#### Obsidian 연동
```bash
brew install --cask obsidian  # macOS
```

### 시스템 활성화
1. 이 레포지토리를 클론하거나 다운로드
2. Claude Code 작업 디렉토리로 이동
3. Claude Code 재시작
4. 명령어 사용 가능 확인:
   ```
   /second-brain-building
   /create-agent
   /km
   /save-prompt
   /find-prompt
   ```

---

## 빠른 시작

### 1. 학습 시작하기
```bash
# Python 학습 세션 시작
/second-brain-building "Python 학습 시작"

# 질문하기
/second-brain-building "Python 데코레이터에 대해 알려줘"

# 계속 질문
/second-brain-building "데코레이터를 실제로 어떻게 사용하나요?"

# 보고서 생성
/second-brain-building "보고서"
```

### 2. Agent 만들기
```bash
/create-agent "GitHub 이슈를 자동으로 분류하고 라벨을 붙이는 시스템"
```

### 3. 지식 저장하기
```bash
# 대화 후
/km "이 대화 내용 저장해줘"
```

### 4. 프롬프트 저장/검색
```bash
# 저장
/save-prompt "효과적인 코드 리뷰 가이드" --category coding

# 검색
/find-prompt "코드 리뷰"
```

---

## 시스템별 사용법

### Second Brain Building 상세 가이드

#### Mode A: 학습 모드 (기본)
```
session-manager → web-researcher → note-enricher
    → smart-organizer → moc-storyteller → link-weaver
```

**예시**:
```bash
User: "웹 크롤러 백엔드 개발을 공부하고 싶어"
System: ✅ 세션 생성 → 질문 대기

User: "웹 크롤러란 뭐야?"
System: 리서치 → 노트 생성 → 분류 → MOC 업데이트 → 링크 생성
        ✅ 노트 완료 → 다음 질문 대기

User: "웹 크롤러의 구성 요소는?"
System: [동일한 워크플로우]
        ✅ 총 2개 노트 → 다음 질문 대기
```

#### Mode B: 보고서 생성 모드
```
session-manager → report-generator
```

**예시**:
```bash
User: "보고서"
System: ✅ docx 파일 생성 → 학습 계속 가능
```

#### 세션 재개
같은 날짜에 동일 도메인으로 다시 시작하면 자동 재개:
```bash
# 오전
/second-brain-building "Python 학습 시작"
/second-brain-building "Python 기초 문법은?"

# 오후 (자동 재개)
/second-brain-building "Python 고급 문법은?"
```

---

### Agent Creator 상세 가이드

#### 간단한 Agent 생성
```bash
/create-agent "웹사이트를 크롤링하고 내용을 요약해줘"
```

**결과**:
- 2개 SubAgent 식별: `web-crawler`, `content-summarizer`
- 3개 파일 생성:
  - `.claude/commands/web-crawler-summary.md`
  - `.claude/agents/web-crawler.md`
  - `.claude/agents/content-summarizer.md`

#### 복잡한 Agent 생성
```bash
/create-agent "블로그 포스트 자동 작성 시스템:
1. 주제 조사
2. 개요 작성
3. 내용 작성
4. SEO 최적화"
```

**결과**:
- 4개 SubAgent 식별
- 5개 파일 생성 (1개 커맨드 + 4개 SubAgent)
- 검증 통과 (warnings 포함)

---

### Knowledge Management 상세 가이드

#### 대화 내용 저장
```bash
# 대화 진행
User: "Claude Code의 Agent 시스템에 대해 설명해줘"
Claude: [상세한 설명]

# 저장
User: /km "이 내용 정리해서 노트로 만들어줘"
```

**결과**:
```
✅ 지식 노트 생성 완료!

📄 생성된 파일:
→ knowledge/programming/claude/agent-system.md

📊 업데이트된 파일:
→ knowledge/MOC/programming.md (새 항목 추가)
→ knowledge/programming/claude/claude-code-basics.md (역방향 링크 추가)

🔗 연결:
- 관련 노트: 3개
- 새로 추가된 링크: 5개

🏷️ 메타데이터:
- 제목: Claude Code Agent 시스템
- 카테고리: programming/claude
- 태그: claude, agent, automation
```

---

### Prompts Management 상세 가이드

#### 프롬프트 저장
```bash
# 기본 저장
/save-prompt

# 메타데이터와 함께 저장
/save-prompt "Web Scraper 완벽 가이드" --category coding --tags web-scraping,puppeteer,nodejs
```

#### 프롬프트 검색
```bash
# 키워드 검색
/find-prompt "web scraping"

# 카테고리 검색
/find-prompt --category coding

# 태그 검색
/find-prompt --tags nodejs,automation

# 조합 검색
/find-prompt "api" --category coding --tags rest,graphql
```

---

## 핵심 기능

### 1. 링크 인덱스 최적화

**문제**: 50개 노트가 있는 세션에서 관련 노트를 찾으려면 모든 파일을 읽어야 함 (100K 토큰)

**해결**: `link-index.json` 사용

```json
{
  "notes": {
    "Python 데코레이터": {
      "path": "학습내용/개념/Python 데코레이터.md",
      "description": "함수를 수정하는 고차 함수로, @ 기호를 사용...",
      "keywords": ["데코레이터", "함수", "고차 함수"],
      "tags": ["python", "고급"],
      "category": "개념",
      "outgoing_links": ["Python 함수", "고차 함수"],
      "incoming_links": []
    }
  }
}
```

**효과**:
- 50개 노트 세션: 100K → 3K 토큰 (97% 절감)
- 세션 재개 시 10배 빠른 속도
- Description 필드로 정확한 관련성 판단

### 2. Description 기반 스마트 매칭

각 노트의 YAML frontmatter에 `description` 필드 포함:

```yaml
---
title: Python 데코레이터
description: 함수를 수정하는 고차 함수로, @ 기호를 사용하여 기존 함수의 동작을 변경하거나 확장하는 Python 기능
tags: [python, decorator]
---
```

**장점**:
- 전체 파일 읽지 않고 내용 파악
- 관련 노트 탐지 정확도 향상
- 링크 작업 시 빠른 참고

### 3. docx-js 기반 전문 보고서

GitHub [anthropics/skills](https://github.com/anthropics/skills/tree/main/skills/docx)의 docx-js 스킬 활용:

```javascript
// Node.js 스크립트 자동 생성
const docx = require('docx');
const { Document, Paragraph, HeadingLevel } = docx;

const doc = new Document({
  sections: [{
    children: [
      new Paragraph({
        text: "학습 보고서",
        heading: HeadingLevel.HEADING_1
      }),
      // ...
    ]
  }]
});
```

**특징**:
- 주 방식: docx-js (Node.js)
- Fallback: pandoc
- 전문적인 스타일링 및 구조화

### 4. 관련도 점수 계산

```
점수 = 0

제목 매칭:
  키워드 정확 일치: +10점
  키워드 부분 일치: +5점

Description 매칭:
  키워드 포함: +3점
  공통 단어 (최대 10점): +2점/단어

태그 매칭:
  공통 태그: +3점/태그

카테고리 매칭:
  동일 카테고리: +5점
  관련 카테고리: +2점

임계값:
  10점 이상: 관련 노트
  20점 이상: 강한 관련성
  30점 이상: 매우 강한 관련성
```

---

## 프로젝트 구조

```
.
├── .claude/
│   ├── commands/                      # 메인 명령어
│   │   ├── second-brain-building.md   # 학습 시스템 오케스트레이터
│   │   ├── Agent-Creator/
│   │   │   └── create-agent.md        # Agent 생성 오케스트레이터
│   │   ├── knowledge/
│   │   │   └── km.md                  # 지식 관리 오케스트레이터
│   │   └── prompts-manage/
│   │       ├── save-prompt.md         # 프롬프트 저장
│   │       └── find-prompt.md         # 프롬프트 검색
│   │
│   ├── agents/                        # SubAgent 정의
│   │   ├── second-brain-building/     # 7개 SubAgent
│   │   │   ├── session-manager.md
│   │   │   ├── web-researcher.md
│   │   │   ├── note-enricher.md
│   │   │   ├── smart-organizer.md
│   │   │   ├── moc-storyteller.md
│   │   │   ├── link-weaver.md
│   │   │   └── report-generator.md
│   │   │
│   │   ├── Agent-Creator/             # 4개 SubAgent
│   │   │   ├── requirements-analyzer.md
│   │   │   ├── code-generator.md
│   │   │   ├── validator.md
│   │   │   └── report-generator.md
│   │   │
│   │   ├── knowledge/                 # 3개 SubAgent
│   │   │   ├── knowledge-analyzer.md
│   │   │   ├── note-writer.md
│   │   │   └── knowledge-linker.md
│   │   │
│   │   └── prompts-manage/            # 2개 SubAgent
│   │       ├── prompt-saver.md
│   │       └── prompt-finder.md
│   │
│   ├── scripts/
│   │   └── update-moc.sh              # MOC 업데이트 스크립트
│   │
│   └── settings.json                  # Claude Code 설정
│
├── knowledge/                         # 지식 베이스
│   ├── MOC/                           # Map of Contents
│   ├── programming/
│   ├── system-design/
│   └── prompts/
│
├── YYYYMMDD_도메인명/                 # 학습 세션 (동적 생성)
│   ├── MOC/
│   │   ├── 00_INDEX.md
│   │   └── link-index.json
│   └── 학습내용/
│
└── README.md                          # 이 파일
```

---

## 성능 최적화

### 토큰 사용량 비교

#### Second Brain Building (50개 노트 세션)

| 방식 | 토큰 사용량 | 시간 | 절감률 |
|------|------------|------|--------|
| **전통 방식** (전체 파일 읽기) | ~100,000 | 30-60초 | - |
| **링크 인덱스** (선택적 읽기) | ~3,000 | 5-10초 | **97%** |

#### Knowledge Management (대화 저장)

| 단계 | 입력 크기 | 목적 |
|------|----------|------|
| knowledge-analyzer | 200-300 단어 (요약) | 분류 및 분석 |
| note-writer | 전체 대화 | 상세 노트 생성 |
| knowledge-linker | JSON 결과 | 링크 생성 |

**최적화 포인트**:
- 분석 단계는 요약만 사용 → 토큰 절약
- 노트 작성 시에만 전체 대화 사용 → 품질 유지

### 세션 재개 속도

- **전통 방식**: 전체 파일 재스캔 (30-60초)
- **링크 인덱스**: JSON 파일 1개만 로드 (5-10초)
- **10배 빠른 재개**

---

## 문제 해결

### Second Brain Building

#### 세션 초기화 실패
**증상**: "Session initialization failed" 에러

**해결**:
1. 현재 디렉토리 쓰기 권한 확인
2. 도메인명에 특수문자 제거
3. 간단한 도메인명으로 재시도 (예: "Python", "JavaScript")

#### 웹 리서치 실패
**증상**: "Web research failed" 에러

**해결**:
1. 인터넷 연결 확인
2. curl/wget 설치 확인: `curl --version`
3. 수동으로 학습 내용 제공하여 계속 진행 가능

#### 보고서 생성 실패
**증상**: "Report generation failed" 에러

**해결**:
1. **docx-js 방식** (권장):
   ```bash
   node --version              # Node.js 확인
   npm install -g docx         # docx 설치
   ```
2. **pandoc 방식** (Fallback):
   ```bash
   brew install pandoc         # macOS
   which pandoc                # 설치 확인
   ```
3. 최악의 경우 Markdown 파일로 제공

#### 링크가 Obsidian에서 안 보임
**증상**: 양방향 링크가 작동하지 않음

**해결**:
1. `[[wikilink]]` 형식 확인
2. "## 관련 노트" 섹션 존재 확인
3. 같은 vault에 노트들이 있는지 확인
4. Obsidian vault 새로고침

---

### Agent Creator

#### 요구사항 분석 실패
**증상**: "요구사항 분석 실패" 에러

**해결**:
1. 요구사항을 더 구체적으로 작성
2. 예시: "이메일을 분류하고 자동 답장하는 시스템"
3. 단계별로 명확히 설명

#### 파일 생성 실패
**증상**: "파일 생성 실패" 에러

**해결**:
1. `.claude/commands/` 및 `.claude/agents/` 디렉토리 존재 확인
2. 파일 쓰기 권한 확인
3. 디렉토리 수동 생성 후 재시도

---

### Knowledge Management

#### YAML 파싱 에러
**증상**: Obsidian에서 YAML frontmatter 오류

**해결**:
1. `related` 필드에 따옴표 사용: `- "[[note-name]]"`
2. 들여쓰기 정확히 2칸
3. `fix_yaml.py` 스크립트 실행:
   ```bash
   python3 fix_yaml.py
   ```

#### MOC 업데이트 실패
**증상**: "링크 생성 부분 실패" 에러

**해결**:
1. `knowledge/MOC/` 디렉토리 존재 확인
2. 수동으로 MOC 파일 생성:
   ```markdown
   # Map of Contents

   ## 카테고리

   - [[노트1]]
   - [[노트2]]
   ```
3. `.claude/scripts/update-moc.sh` 실행

---

### Prompts Management

#### 프롬프트 저장 실패
**증상**: "프롬프트 저장 실패" 에러

**해결**:
1. `knowledge/prompts/` 디렉토리 생성
2. 카테고리 폴더 생성:
   ```bash
   mkdir -p knowledge/prompts/{coding,writing,analysis,automation}
   ```

#### 프롬프트 검색 결과 없음
**증상**: "No prompts found" 메시지

**해결**:
1. 키워드 변경하여 재검색
2. `--category` 옵션 없이 전체 검색
3. `knowledge/prompts/` 디렉토리 확인

---

## Obsidian 연동

### 추천 설정

#### 1. Vault 설정
- Obsidian에서 `YYYYMMDD_도메인명/` 폴더를 vault로 열기
- 또는 기존 vault에 심볼릭 링크 생성:
  ```bash
  ln -s "/path/to/20251226_Python" ~/Obsidian/Learning/
  ```

#### 2. 플러그인 추천
- **Dataview**: YAML frontmatter 활용
- **Graph Analysis**: 링크 관계 시각화
- **Templater**: 노트 템플릿 관리
- **Tag Wrangler**: 태그 관리

#### 3. Graph View 활용
- 모든 양방향 링크가 그래프에 표시됨
- 관련 노트들이 자동으로 클러스터링
- 시각적 학습 경로 탐색

---

## 고급 기능

### 멀티 세션 관리
여러 도메인 동시 학습 가능:
```
20251226_Python/
20251226_JavaScript/
20251226_머신러닝/
```
각 세션은 독립적인 link-index 보유.

### 점진적 학습
한 번에 한 노트씩 추가:
- 각 노트 자동 통합
- MOC 점진적 업데이트
- 링크 인덱스 자동 성장

### 카테고리 진화
- 새 카테고리 필요 시 자동 생성
- 기존 카테고리는 세션 간 보존
- 내용 기반 스마트 분류

### 커스터마이징

#### 웹 검색 동작 조정
파일: `.claude/agents/second-brain-building/web-researcher.md`
- 섹션: "작업 프로세스"
- 수정: 검색 쿼리 구성, 결과 필터링

#### 노트 포맷 변경
파일: `.claude/agents/second-brain-building/note-enricher.md`
- 섹션: "출력 형식"
- 수정: YAML frontmatter 필드, 마크다운 구조

#### 링크 민감도 조정
파일: `.claude/agents/second-brain-building/link-weaver.md`
- 섹션: "관련도 점수 계산"
- 현재 임계값: 10점
- 더 많은 링크: 임계값 낮추기
- 더 적은 링크: 임계값 높이기

---

## 기여

이 프로젝트는 Claude Code의 Agent 시스템을 활용한 자동화 도구입니다.

### 기여 방법
1. Fork this repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

### 개선 아이디어
- 새로운 SubAgent 추가
- 기존 Agent 최적화
- 문서 개선
- 버그 리포트

---

## 참고 자료

- [Claude Code 문서](https://docs.claude.com/claude-code)
- [Anthropic Skills - docx](https://github.com/anthropics/skills/tree/main/skills/docx)
- [Obsidian 공식 사이트](https://obsidian.md/)
- [docx-js 문서](https://docx.js.org/)
- [Pandoc 문서](https://pandoc.org/)

---

## 라이선스

MIT License

---

## 버전

**현재 버전**: 1.0.0

### 시스템별 버전
- **Second Brain Building**: v1.0 (7 SubAgents, 97% 토큰 절감)
- **Agent Creator**: v1.0 (4 SubAgents, 자동 생성 및 검증)
- **Knowledge Management**: v1.0 (3 SubAgents, Obsidian 통합)
- **Prompts Management**: v1.0 (2 SubAgents, 프롬프트 라이브러리)

### 주요 기능
- 17개 전문화된 SubAgent
- 링크 인덱스 최적화 (97% 토큰 절감)
- Description 기반 스마트 매칭
- docx-js 기반 보고서 생성
- YAML frontmatter 표준화
- Obsidian 완전 호환

---

**Made with ❤️ using Claude Code**
