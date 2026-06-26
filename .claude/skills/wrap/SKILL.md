---
name: wrap
description: Session end - document updates, commit
required_context:
  - .claude/ai-context/architecture.md
---

# Wrap

## Flow
```
Git Status → Doc Check → User Selection → Execute → Complete
```

## Execution

1. **Git Status**
   ```bash
   git status --short
   git diff --stat HEAD~3
   ```

2. **Doc Check Checklist (MUST)**
   | Change | Target | Required |
   |--------|--------|----------|
   | trait/type | architecture.md | 구조 변경 시 |
   | convention | conventions.md | 새 패턴 시 |
   | **결정사항** | **.dev/DECISIONS.md** | **새 기능/설계 시** |

   **DECISIONS.md 기록 (필수 체크)**:
   - [ ] 새 기능 구현 → 결정 배경, 대안, 이유 기록
   - [ ] PLAN과 실제 구현 차이 → `**구현 노트**` 추가
   - [ ] 새로운 패턴/컨벤션 → conventions.md도 업데이트

3. **Plan Reconciliation (MUST)**

   PLAN의 provenance 태그/게이트(`[unverified-gate]`/`[agent-inferred]`/Phase 0)를 1:1로 정산한다 — **닫거나(confirmed/falsified/changed) 명시적 위임(delegated). 조용한 TODO 금지.** 미정산이면 wrap 미완료.

   상세 절차·delegated 블록·승격 기준(WRAP=상세/DECISIONS=why/CLAUDE.md=치명·반복) → `references/reconciliation.md`

4. **User Selection**: AskUserQuestion
5. **Execute**: Run selected items

## DSL Rules (ai-context)
- Table > prose
- Codeblock > description
- Core only, minimize lines

## Commit
```
{type}({scope}): {summary}
```

## Completion
wrap complete = **skill chain finished**
Next task starts with new `/clarify` or `/next`
