# Plan Reconciliation (gate를 닫거나 명시적으로 위임)

PLAN의 provenance 태그/게이트를 1:1로 정산한다. **조용한 TODO 금지 — 닫거나 위임, 둘 중 하나.** 이게 "구현 후 예상 못한 상황"의 누수 지점을 막는다.

각 `[unverified-gate]` / `[agent-inferred]` / Phase 0 게이트에 대해:
- **confirmed**: probe 재실행 통과 → WRAP에 evidence 기록
- **falsified**: 가정이 틀림 → 실제로 한 것 + 왜 바뀌었는지 WRAP에, 방향 변경이면 DECISIONS에도
- **changed (피벗)**: WRAP에 상세 + DECISIONS에 why
- **delegated** (wrap 시점에 못 닫음 — merge 후/권한/운영자/prod 스모크 필요): 아래 블록으로 명시
```
- Gate: <무엇>
- Status: delegated
- Owner: user | ops | next-agent
- Due/Trigger: after merge | after deploy | <조건>
- Probe: <명령 또는 정확한 수동 체크>
- Risk if skipped: <영향>
```

## 승격 기준 (어디에 기록 — 과확장 금지)
| 대상 | 무엇을 |
|------|--------|
| WRAP | 실제 수행/검증/변경/피벗의 **상세** (전부) |
| DECISIONS | **왜** 방향이 바뀌었나 + 반복 가치 있는 교훈만 |
| CLAUDE.md (gotcha) | repo 전역 승격할 만큼 **반복·치명적**인 것만 |

> DECISIONS에 검증 결과를 전부 넣지 않는다 (잡음). WRAP=상세, DECISIONS=why, CLAUDE.md=치명·반복.
> **PLAN의 gate/assumption이 미정산이면 wrap 완료로 보지 않는다** — 전부 confirmed/falsified/changed/delegated 후 완료.
