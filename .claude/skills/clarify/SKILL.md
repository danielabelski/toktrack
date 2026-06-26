---
name: clarify
description: |
  Adaptive requirements clarification with auto-depth routing.
  Shallow (Q&A) for simple tasks, Deep (exploration + DRAFT + PLAN) for complex ones.
  Escalates automatically when ambiguity persists.
required_context:
  - .claude/ai-context/architecture.md
  - .claude/ai-context/conventions.md
allowed-tools:
  - Read
  - Grep
  - Glob
  - Task
  - Write
  - AskUserQuestion
---

# /clarify — Adaptive Requirements Clarification

## Chain (MUST)
| Previous | Current | Next |
|----------|---------|------|
| Session start | /clarify | Present PLAN inline → /implement |

## Core Model

```
/clarify → Measure complexity → Clear enough?
                                ├─ Yes → Present PLAN inline → /implement
                                └─ No  → Deeper clarify (explore, analyze, DRAFT...)
                                         → Re-measure → Repeat
```

Exit condition: **"Is this enough info to implement?"** — Critical Unknown=0 + 잔여는 가시화(Provenance).

---

## 참조 파일 (필요 시 로드 — chaining)

| 언제 | 파일 |
|------|------|
| 핵심 결정·가정에 출처 태그 / probe 판단 | `references/provenance.md` |
| PLAN 작성 직전 사용자 확인 | `references/checkpoint.md` |
| 문서 권위·읽는 순서 헷갈릴 때 | `references/doc-roles.md` |
| Deep 경로 전체 절차 | `deep/DEEP.md` |
| PLAN/DRAFT 구조 (Lite/Full + Clarify Verdict) | `templates/` |

> 인라인 핵심만: **probe-don't-tag**(싸게 실측되면 태그 말고 실측), **PLAN=의도 · WRAP/DECISIONS=사실**, **추론은 숨기지 않는다**. 상세는 위 reference.

---

## Step 0: Route — Complexity Assessment

Measure complexity internally upon receiving request (do not expose to user).

### Complexity Signals

| Signal | LOW | HIGH |
|--------|-----|------|
| Request length | Short and specific | Long or ambiguous |
| Keywords | "add", "fix", "change" | "design", "migration", "from scratch" |
| Uncertainty | None | "not sure", "how should I" |
| Impact scope | Single file/module | Cross-cutting, multiple services |
| Risk | Low (UI, text) | High (DB, auth, breaking API) |
| Existing patterns | Clearly exist | None or unfamiliar stack |

- **LOW** → Shallow Path (completed within this file)
- **HIGH** → Deep Path (see `deep/DEEP.md`)
- **Ambiguous** → Start Shallow, monitor escalation conditions

---

## Shallow Path (Low Complexity)

Remove ambiguity via quick Q&A, generate minimal specs, and present the PLAN inline.

### Execution

1. **Record**: Log original request + identify ambiguous parts
2. **Question**: `AskUserQuestion` (specific options, 2-3 rounds)
3. **Escalation Check**: Check escalation conditions (see below)
4. **Create DRAFT**: Write `.dev/specs/{name}/DRAFT.md` (minimal version — What, Why, Scope, Success Criteria)
5. **Summary + Create PLAN**: Before/After comparison → Write `.dev/specs/{name}/PLAN.md`
6. **Present PLAN**: Present the PLAN inline in the conversation (do NOT enter plan mode), then immediately call `/implement`. plan file은 반드시 `.dev/specs/{name}/PLAN.md`에 작성

### Rules
- No assumptions → Ask questions
- Clarify to TDD-ready level
- Target resolution within 3 rounds

### Escalation → Deep Path

Switch to Deep Path if any of these are detected:

- Scope still undefined after 3 rounds of questions
- New uncertainties keep emerging from user answers
- Impact scope expanded beyond initial estimate (single → multi-module)
- Risk indicators found (DB schema, auth, breaking changes)
- User doesn't know the approach itself ("I don't know how to do this")

On switch: Inform "Scope is more complex than expected. Exploring the codebase first." then follow the process in `deep/DEEP.md`.

---

## Deep Path

**When complexity is HIGH or escalated from Shallow.**

See `deep/DEEP.md` for the full process.

Summary:
1. Classify intent (7 types) → Determine strategy
2. 3 parallel exploration agents → Understand codebase
3. Generate DRAFT → Interview → Continuously update
4. On user explicit request → Analysis agents → Generate PLAN → Reviewer loop
5. Present PLAN inline → immediately call `/implement` (no plan mode entry)

---

## DECISIONS.md Recording (MUST)

Record decisions in `.dev/DECISIONS.md` before finalizing plan:

| Situation | Required Record |
|-----------|----------------|
| New feature design | Decision background, alternatives, reasoning |
| Architecture choice | Considered options, selection rationale |
| Trade-offs | What was sacrificed and what was gained |

```markdown
## YYYY-MM-DD: {feature-name}
- **Decision**: What was decided
- **Reason**: Why this choice was made
- **Alternatives**: Options considered but not chosen
- **Reference**: .dev/specs/{feature-name}/PLAN.md (if exists)
```

---

## Plan File Requirements

Plan files must include:
- Specify implementation via `/implement` skill
- Verification method (test execution)
- Confirmation that `.dev/DECISIONS.md` recording is complete

**Plan File Location**: PLAN은 반드시 `.dev/specs/{name}/PLAN.md`에 작성한다.

**Important**: Plans that do not use `/implement` will not be approved.

---

## NEXT STEP (Auto-execute)

After presenting the PLAN inline, call `/implement` **immediately**. Do NOT enter plan mode; do not ask "Should I implement?".
