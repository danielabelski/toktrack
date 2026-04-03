---
name: review
description: |
  Multi-agent code review for Rust CLI/TUI.
  UX Review 비활성 (터미널 UI — 웹 프론트엔드 없음). Code Review만 실행.
  Rust/clippy 특화 체크리스트 포함.
required_context:
  - .claude/ai-context/architecture.md
  - .claude/ai-context/conventions.md
---

# Review (toktrack override)

글로벌 `/review` 멀티-에이전트 패턴을 따르되, 다음을 override:

## Override: UX Review 비활성

이 프로젝트는 터미널 TUI 앱 — **UX Review Agent를 실행하지 않는다.**
Code Review Agent만 단독 실행.

## Override: Code Review 체크리스트 확장

글로벌 체크리스트에 더해, Code Review Agent 프롬프트에 다음을 추가:

### Rust 전용

| Category | Items |
|----------|-------|
| Safety | `unsafe` 사용 최소화, 정당한 사유 주석 |
| Ownership | 불필요한 `.clone()`, `to_string()`, `to_owned()` |
| Error | `anyhow`/`thiserror` 패턴 일관성, `unwrap()` 금지 (테스트 제외) |
| Performance | 불필요한 allocation, `Vec` vs iterator chain, `Box<dyn>` vs generic |
| SIMD | simd-json 파싱 경로에서 fallback 분기 확인 |
| Concurrency | rayon 병렬 경로에서 shared mutable state 확인 |

### TUI 전용

| Category | Items |
|----------|-------|
| Widget | ratatui `Widget` trait 구현 일관성 |
| Theme | `theme.rs` 시맨틱 컬러 사용 (하드코딩 색상 금지) |
| Layout | 터미널 리사이즈 대응 (`Rect` 경계 검사) |
| Input | 키보드 이벤트 핸들링 누락 (help에 등록된 단축키 vs 실제 핸들러) |

### Clippy/Fmt 사전 검증

Code Review Agent는 리뷰 전에 다음을 확인:

```bash
cargo fmt --check
cargo clippy --all-targets --all-features -- -D warnings
```

clippy 경고가 있으면 리뷰 시작 전 FAIL 처리 (verify에서 잡혔어야 함).

## Execution

1. Collect context (diff, conventions, architecture, Sprint Contract)
2. Launch **Code Review Agent only** (feature-dev:code-reviewer)
   - 글로벌 `agents/code-review.md` 프롬프트 + 위 Rust/TUI 체크리스트 append
3. Parse verdict → PASS → /wrap, FAIL → fix → /verify → re-review

## Rules
- UX Review Agent 실행 금지 (TUI 프로젝트)
- PASS → /wrap 즉시 실행
- FAIL → fix → /verify → re-review (max 3)
