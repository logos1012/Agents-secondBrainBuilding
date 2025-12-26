# Second Brain Building 시스템

도메인별 자동 학습 구조 생성 및 MOC 기반 지식 관리 시스템입니다.

## 개요

Second Brain Building은 Claude Code를 위한 AI 기반 학습 노트 자동화 시스템으로, 특정 도메인에 대해 학습할 때 다음과 같은 작업을 자동으로 수행합니다:

- 🗂️ **자동 폴더 구조 생성**: `YYYYMMDD_도메인명` 형식의 체계적인 학습 공간
- 🔍 **웹 기반 리서치**: 학습 주제에 대한 자동 검색 및 출처 링크 포함
- 📝 **풍부한 노트 생성**: 예시와 설명이 포함된 Obsidian 호환 마크다운 노트
- 🏷️ **스마트 분류**: 자동 카테고리 분류 및 폴더 정리
- 📚 **MOC 스토리텔링**: 학습 가이드 형태의 목차 자동 업데이트
- 🔗 **양방향 링크**: Obsidian wikilink 형식의 스마트 링크 생성
- 📊 **보고서 생성**: 학습 내용을 전문적인 DOCX 보고서로 변환
- ⚡ **토큰 효율 최적화**: 링크 인덱스를 통한 97% 토큰 절감 (50+ 노트 세션)

## 주요 특징

### 1. 링크 인덱스 최적화
전체 파일을 읽지 않고 `link-index.json`을 통해 관련 노트를 빠르게 탐지합니다.

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
각 노트의 YAML frontmatter에 `description` 필드를 포함하여:
- 전체 파일 읽지 않고 내용 파악
- 관련 노트 탐지 정확도 향상
- 링크 작업 시 빠른 참고

### 3. docx-js 기반 전문 보고서
GitHub [anthropics/skills](https://github.com/anthropics/skills/tree/main/skills/docx)의 docx-js 스킬을 활용한 정교한 문서 생성:
- 주 방식: docx-js (Node.js)
- Fallback: pandoc
- 전문적인 스타일링 및 구조화

## 설치 및 설정

### 필수 요구사항
- **Claude Code**: 최신 버전
- **파일 쓰기 권한**: 현재 디렉토리

### 선택 사항 (전체 기능 사용 시)
```bash
# 웹 리서치용 (web-researcher)
curl --version  # 또는 wget

# 보고서 생성용 (report-generator)
npm install -g docx        # docx-js 방식 (권장)
brew install pandoc        # Fallback 방식

# 노트 확인용
brew install --cask obsidian  # Obsidian 앱
```

### 시스템 활성화
1. Claude Code 재시작
2. 명령어 사용 가능 확인:
   ```
   /second-brain-building
   ```

## 사용 방법

### 기본 사용법

#### 1. 새 학습 주제 시작
```
/second-brain-building "Python 학습 시작"
```

**결과**:
```
20251226_Python/
├── MOC/
│   ├── 00_INDEX.md           # 스토리텔링 기반 학습 가이드
│   └── link-index.json       # 링크 최적화 인덱스
└── 학습내용/
    └── (노트들이 자동 분류됨)
```

#### 2. 학습 질문하기
```
/second-brain-building "Python 데코레이터에 대해 알려줘"
```

**진행 과정**:
1. 🔍 웹에서 데코레이터 관련 자료 검색
2. 📝 풍부한 예시가 포함된 노트 생성
3. 🏷️ "개념" 카테고리로 자동 분류
4. 📚 MOC 업데이트 (학습 흐름에 추가)
5. 🔗 관련 노트와 양방향 링크 생성

**생성된 노트 예시**:
```markdown
---
title: Python 데코레이터
description: 함수를 수정하는 고차 함수로, @ 기호를 사용하여 기존 함수의 동작을 변경하거나 확장하는 Python 기능
created: 2025-12-26
category: 개념
domain: Python
tags: [python, decorator, 고차함수, 함수형프로그래밍]
source:
  - https://docs.python.org/3/glossary.html#term-decorator
  - https://realpython.com/primer-on-python-decorators/
---

# Python 데코레이터

## 개념
(상세한 설명...)

## 예시
(코드 블록과 실행 결과...)

## 활용
(실전 활용 방법...)

## 관련 노트
- [[Python 함수]] - 함수의 기본 개념
- [[고차 함수]] - 함수를 다루는 함수
```

#### 3. 보고서 생성
```
/second-brain-building "Python 학습 내용 보고서로 만들어줘"
```

**결과**:
- `Python_학습보고서_20251226.docx` 파일 생성
- docx-js 또는 pandoc 사용 (자동 선택)
- 카테고리별 구조화, 목차, 참고문헌 포함

### 고급 사용법

#### 세션 재개
같은 날짜에 동일 도메인으로 다시 시작하면 자동 재개:
```
/second-brain-building "Python 클로저 학습"
```
→ 기존 `20251226_Python/` 세션 감지 및 계속

#### 특정 카테고리 보고서
```
/second-brain-building "Python 개념 카테고리만 보고서로"
```

## 시스템 구조

### SubAgents (7개)

| SubAgent | 역할 | 도구 |
|----------|------|------|
| **session-manager** | 세션 초기화 및 복구 | Glob, Read, Write, Bash |
| **web-researcher** | 웹 검색 및 자료 수집 | Bash |
| **note-enricher** | 풍부한 노트 생성 | Write, Read |
| **smart-organizer** | 자동 카테고리 분류 | Glob, Read, Bash |
| **moc-storyteller** | MOC 스토리텔링 업데이트 | Read, Edit, Write |
| **link-weaver** | 양방향 링크 생성 (링크 인덱스) | Read, Edit, Write, Grep |
| **report-generator** | DOCX 보고서 생성 | Read, Write, Bash, Glob |

### 실행 워크플로우

#### Mode A: 학습 모드 (기본)
```
session-manager → web-researcher → note-enricher
    → smart-organizer → moc-storyteller → link-weaver
```

#### Mode B: 보고서 생성 모드
```
session-manager → report-generator
```

### 폴더 구조

```
YYYYMMDD_도메인명/
├── MOC/
│   ├── 00_INDEX.md              # 학습 가이드 (스토리텔링)
│   └── link-index.json          # 링크 최적화 인덱스
└── 학습내용/
    ├── 개념/
    │   ├── Python 기초.md
    │   ├── Python 함수.md
    │   └── Python 데코레이터.md
    ├── 실습/
    │   ├── 함수 실습.md
    │   └── 데코레이터 실습.md
    └── 도구/
        └── pip 사용법.md
```

## 트리거 명령어

시스템을 실행할 수 있는 명령어:
- `/second-brain-building "세컨드 브레인 시작해줘"`
- `/second-brain-building "{도메인명} 학습 시작"`
- `/second-brain-building "학습 노트 정리해줘"`
- `/second-brain-building "학습 내용 보고서로 만들어줘"`
- `/second-brain-building "지식 관리 시스템 실행"`

## 문제 해결

### 세션 초기화 실패
**증상**: "Session initialization failed" 에러
**해결**:
1. 현재 디렉토리 쓰기 권한 확인
2. 도메인명에 특수문자 제거
3. 간단한 도메인명으로 재시도 (예: "Python", "JavaScript")

### 웹 리서치 실패
**증상**: "Web research failed" 에러
**해결**:
1. 인터넷 연결 확인
2. curl/wget 설치 확인: `curl --version`
3. 수동으로 학습 내용 제공하여 계속 진행 가능

### 보고서 생성 실패
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

### 링크가 Obsidian에서 안 보임
**증상**: 양방향 링크가 작동하지 않음
**해결**:
1. `[[wikilink]]` 형식 확인
2. "## 관련 노트" 섹션 존재 확인
3. 같은 vault에 노트들이 있는지 확인
4. Obsidian vault 새로고침

### link-index.json 파일 없음
**증상**: "link-index.json not found" 경고
**해결**:
- 정상 동작입니다! 첫 번째 노트 생성 시 자동으로 생성됩니다.
- 수동 편집하지 마세요.

## 성능 메트릭

### 토큰 사용량 비교 (50개 노트 세션)

| 방식 | 토큰 사용량 | 시간 | 절감률 |
|------|------------|------|--------|
| **전통 방식** (전체 파일 읽기) | ~100,000 | 30-60초 | - |
| **링크 인덱스** (선택적 읽기) | ~3,000 | 5-10초 | **97%** |

### 세션 재개 속도
- 전통 방식: 전체 파일 재스캔
- 링크 인덱스: JSON 파일 1개만 로드
- **10배 빠른 재개**

## Obsidian 연동

### 추천 설정

1. **Vault 설정**:
   - Obsidian에서 `20251226_Python/` 폴더를 vault로 열기
   - 또는 기존 vault에 심볼릭 링크 생성

2. **플러그인 추천**:
   - **Dataview**: YAML frontmatter 활용
   - **Graph Analysis**: 링크 관계 시각화
   - **Templater**: 노트 템플릿 관리

3. **Graph View 활용**:
   - 모든 양방향 링크가 그래프에 표시됨
   - 관련 노트들이 자동으로 클러스터링
   - 시각적 학습 경로 탐색

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

## 기술 세부사항

### YAML Frontmatter 구조
```yaml
---
title: 노트 제목
description: 1-2문장 요약 (링크 작업용)
created: YYYY-MM-DD
category: 개념|실습|도구|트러블슈팅
domain: 도메인명
tags: [태그1, 태그2, ...]
source:
  - URL1
  - URL2
---
```

### 링크 인덱스 구조
```json
{
  "version": "1.0",
  "last_updated": "2025-12-26T10:30:00Z",
  "total_notes": 50,
  "notes": {
    "노트제목": {
      "path": "학습내용/카테고리/파일명.md",
      "description": "짧은 요약",
      "keywords": ["키워드1", "키워드2"],
      "tags": ["태그1", "태그2"],
      "category": "카테고리",
      "outgoing_links": ["연결된노트1", "연결된노트2"],
      "incoming_links": ["역링크노트1"]
    }
  }
}
```

### 관련도 점수 계산

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

## 커스터마이징

### 웹 검색 동작 조정
파일: `.claude/agents/second-brain-building/web-researcher.md`
- 섹션: "작업 프로세스"
- 수정: 검색 쿼리 구성, 결과 필터링

### 노트 포맷 변경
파일: `.claude/agents/second-brain-building/note-enricher.md`
- 섹션: "출력 형식"
- 수정: YAML frontmatter 필드, 마크다운 구조

### 카테고리 커스터마이징
파일: `.claude/agents/second-brain-building/smart-organizer.md`
- 섹션: "카테고리 분류 로직"
- 기본: 개념, 실습, 도구, 이론, 프로젝트
- 필요 시 추가/변경 가능

### 링크 민감도 조정
파일: `.claude/agents/second-brain-building/link-weaver.md`
- 섹션: "관련도 점수 계산"
- 현재 임계값: 10점
- 더 많은 링크: 임계값 낮추기
- 더 적은 링크: 임계값 높이기

### MOC 스타일 변경
파일: `.claude/agents/second-brain-building/moc-storyteller.md`
- 섹션: "스토리텔링 구성"
- 학습 가이드 스타일 및 섹션 구조 조정

### 보고서 템플릿 수정
파일: `.claude/agents/second-brain-building/report-generator.md`
- 섹션: "docx-js 스크립트 생성"
- docx 스타일링, 메타데이터 조정

## 라이선스

MIT License

## 참고 자료

- [Claude Code 문서](https://docs.claude.com/claude-code)
- [Anthropic Skills - docx](https://github.com/anthropics/skills/tree/main/skills/docx)
- [Obsidian 공식 사이트](https://obsidian.md/)
- [docx-js 문서](https://docx.js.org/)
- [Pandoc 문서](https://pandoc.org/)

## 기여

이 프로젝트는 Claude Code의 Agent 시스템을 활용한 자동화 학습 도구입니다.

개선 아이디어나 버그 리포트는 환영합니다!

## 버전

**현재 버전**: 1.0.0
- 7개 SubAgent 시스템
- 링크 인덱스 최적화 (97% 토큰 절감)
- Description 기반 스마트 매칭
- docx-js 기반 보고서 생성

---

**Made with ❤️ using Claude Code**
