# Provenance & Probe (모든 핵심 결정·가정에 적용)

질문 턴을 늘리지 않으면서 "합의 vs 추론"을 가시화한다. PLAN/DRAFT의 핵심 결정마다 태그:

| 태그 | 의미 |
|------|------|
| `[user-confirmed]` | 사용자가 직접 결정 (스코프/제품/플로우) |
| `[verified: <evidence>]` | read-only probe로 실측. evidence=`file:line` 또는 명령 |
| `[agent-inferred]` | 검증 안 한 추론 — **냄새. 개수를 0에 수렴시킨다** |
| `[unverified-gate: probe=<cmd>, owner=<who>, due=<when>]` | 지금 검증 불가 → Phase 0/배포후로 위임 |
| `[external-prereq: <what>]` | 코드 밖 선행조건 (권한·운영자·인프라) |

## probe-don't-tag 원칙
`[agent-inferred]` 하나 = 미뤄둔 폭탄. 붙이기 전에 **싸게 실측되면 실측하고 `[verified]`로 바꾼다.**

**probe 예산 — 아래 3개 중 2개 이상이면 probe, 아니면 assumption으로 남겨도 됨:**
- **싸다**: `rg`/파일 읽기/타입·테스트 타깃/JSON validate/SQL count 로 끝남
- **load-bearing**: 틀리면 구현 방향·배포·데이터 보존이 바뀐다
- **반복 사고점**: 아래 "이 레포 killer" 항목

지금 검증 불가한 것(prod 데이터·외부권한·prod 스모크)만 `[unverified-gate]`로 남기고 **probe 명령을 PLAN Phase 0에 박는다.** 태그는 사실이 아니다 — **probe가 사실이다.** 그래서 태그는 probe를 들고 다닌다.

## Side Effects Checked (이 레포 killer — PLAN Verdict에 필수)
일반 체크리스트는 빈칸 연극이 된다. 이 레포 고정 항목으로:
`make check (fmt+clippy+test) / CI 3 OS 크로스플랫폼 호환 / release-please semver 규칙(feat→minor·fix→patch·BREAKING→major) / simd-json 파서 변경 시 경계 조건·플랫폼별 SIMD 지원 / ratatui TUI 변경 시 렌더링 사이클·터미널 호환성`
