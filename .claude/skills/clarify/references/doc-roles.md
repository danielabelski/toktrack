# 문서 역할 계약 (컴파운딩 SSOT)

미래 세션이 추측 아닌 실측을 하려면 각 문서의 권위를 구분한다.
**읽는 순서: DECISIONS → WRAP → PLAN/DRAFT.**

| 문서 | 역할 | 시점 | 권위 |
|------|------|------|------|
| DRAFT | 합의 형성(사고 과정) | 계획 전 | 낮음 (stale 가능) |
| PLAN | 실행 계약 (implement가 읽음) | 계획 | 의도 — 사실 아님 |
| WRAP | 계획↔현실 정산 (실제 일어난 것) | 구현 후 | 현재 사실 |
| DECISIONS | 영구 why-원장 | 누적 | 영구 진실 |

- PLAN은 구현 *전* 산출물 → assumption이 섞인다. "무엇이 사실인가"의 출처는 PLAN이 아니라 **WRAP/DECISIONS**.
- DRAFT/PLAN 배경 중복 금지 — PLAN은 DRAFT를 *참조*하고 재서술하지 않는다.
