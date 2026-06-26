---
name: verify
description: Self-healing verification loop (test → clippy → fmt)
required_context: []
---

# Verify

## Flow
```
cargo test → cargo clippy → cargo fmt --check
    │            │              │
    └── On fail: fix and retry (notify user after 3 same failures)
```

## Commands
```bash
cargo test --quiet
cargo clippy --all-targets --all-features -- -D warnings
cargo fmt --all -- --check
```

## Verification Honesty (MUST — PASS 게이트)

검증의 신뢰는 "무엇이 통과했나"가 아니라 **"무엇이 *실제로 실행*되어 통과했나"**에 있다. PASS 판정 전 강제.

### Skip ≠ Pass
- `ignored` / `#[ignore]` 로 마킹된 테스트는 **검증되지 않은 것** → green으로 세지 않는다.
- 환경 때문에 skip된 테스트(외부 서비스 부재, 플랫폼 제약 등)는 **BLOCKER**. 못 고치면 PASS가 아니라 "검증 미완 + 사유"로 사용자 에스컬레이션.

### 실행되지 않은 테스트를 검증 근거로 인용 금지
- "X 테스트로 확인했다"는 **그 테스트가 이번 실행에서 실제로 돌아 통과했을 때만** 쓴다.
- 작성만 된 테스트를 "확인됨"의 근거로 삼지 않는다 (false-green = 잘못된 안심).

### 커버리지 정직성 (목 ≠ 실제)
- mock 기반 단위테스트는 **mock 경계 안쪽 로직만** 검증한다. 파일I/O·동시성·simd-json 실 파싱처럼 **mock이 못 보는 동작은 통합 검증으로만** 확인된다.
- 어떤 경로가 mock으로만 덮였으면 "검증됨"이 아니라 **"mock 커버리지만 — 통합 미확인"** 으로 보고한다.

### Acceptance/DoD 대조 (PLAN 게이트 운반)
- PLAN Acceptance/DoD와 implement가 넘긴 `[unverified-gate]`를 읽어, 각 항목이 **이번 실행에서 실제 실행·통과**했는지 대조.
- 실행 불가(prod 스모크 / 외부 서비스 / CI 전용 환경) → green-wash 금지. `[unverified-gate: delegated, owner/due/probe]`로 표기해 **wrap Plan Reconciliation에 운반**(`../wrap/references/reconciliation.md`).

### 보고 형식
- ✅ 실제 실행되어 통과한 것
- ⛔ skip/환경차단된 것 + **사유** (미해결 시 BLOCKER, PASS 아님)
- ⚠️ mock 커버리지만 있고 통합 미확인인 것
- ⏳ Acceptance 중 검증 불가로 wrap에 delegated된 것

## Self-Healing
- Fail → analyze error → fix code → retry
- Same error 3 times → notify user

## Rules
- Required before commit
- Order: test → clippy → fmt
- All must pass to proceed

## Next Step
**Verification Honesty 게이트 통과 시에만** (실제 실행 통과, 미해결 BLOCKER 없음) → 즉시 `/review` 호출. "리뷰할까요?" 묻지 않는다.

미해결 BLOCKER가 있으면 **/review로 넘어가지 않고** 사용자에게 "검증 미완 + 사유 + 필요한 환경 조치"를 보고한다.
