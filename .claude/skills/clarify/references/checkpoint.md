# Pre-Plan Checkpoint (PLAN 작성 직전)

100% 싱크가 아니라 **틀린 가정 조기 노출** 장치. PLAN 쓰기 직전 딱 이 수준만 사용자에게 보인다:

```
## Pre-Plan Checkpoint
- 사용자 결정: [user-confirmed 항목]
- 에이전트 실측: [verified 항목 + evidence]
- 에이전트 추론(미검증): [남은 agent-inferred — 있으면 왜 probe 안 했는지]
- 미검증 게이트: [unverified-gate: probe/owner/due]
- 외부 선행조건: [external-prereq]
방향 틀린 게 있으면 수정, 없으면 PLAN 고정.
```

- 이 체크포인트의 산출물이 곧 provenance 태그라 **추가 노동 0**.
- 추론(미검증)은 숨기지 않는다.
- **auto-reject는 여기서 하지 않는다(throughput) — wrap이 미정산 gate를 reject한다.**
