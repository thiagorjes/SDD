# Tasks — {{FEATURE_NAME}}
_Version: 1.0 | Date: {{DATE}} | Author: {{AUTHOR}}_
_PRD: docs/prd/{{FEATURE_NAME}}-prd.md v{{PRD_VERSION}}_
_TechSpec: docs/techspec/{{FEATURE_NAME}}-techspec.md v{{TECHSPEC_VERSION}}_

---

## Epics Summary

| ID | Epic | Tasks | Total estimate | Can start |
|----|------|-------|---------------|-----------|
| EPIC-01 | {{EPIC_01_NAME}} | {{N_TASKS}} | {{ESTIMATE}} | Immediately |

**Legend:** P ≤ 4h | M 4–8h | G 1–2 days

---

## Dependency Graph

```
EPIC-01
  └── TASK-01.1 → TASK-01.2
```

---

## EPIC-01 — {{EPIC_01_NAME}}

### US-01.1 — {{USER_STORY_NAME}}

#### TASK-01.1 — {{TASK_TITLE}} [P|M|G]
**System:** {{SYSTEM}} | **RF:** {{SOURCE_RF}} | **Dependencies:** none

**Context:**
{{TASK_CONTEXT}}

**What to do:**
- [ ] {{ACTION_1}}
- [ ] {{ACTION_2}}

**Technical guide:**
- File: `{{FILE_PATH}}`
- {{TECHNICAL_DETAIL_1}}

**Acceptance criteria:**
- {{CRITERION_1}}
- {{CRITERION_2}}

---

#### TASK-01.2 — {{TASK_TITLE}} [P|M|G]
**System:** {{SYSTEM}} | **RF:** {{SOURCE_RF}} | **Dependencies:** TASK-01.1 | **[P] with TASK-01.3**

**Context:**
{{TASK_CONTEXT}}

**What to do:**
- [ ] {{ACTION_1}}
- [ ] {{ACTION_2}}

**Acceptance criteria:**
- {{CRITERION_1}}

---

## Prioritized Backlog (Start Order)

| Priority | Task | Reason |
|----------|------|--------|
| 1 | TASK-01.1 | {{PRIORITY_REASON}} |
| 2 | TASK-01.2 | Depends on TASK-01.1 |

## Out of Scope (Future Backlog)

- {{OUT_OF_SCOPE_1}}
