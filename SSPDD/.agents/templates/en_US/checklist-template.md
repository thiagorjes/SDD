# Quality Checklist — {{FEATURE_NAME}} ({{ARTIFACT_TYPE}})
_Date: {{DATE}} | Reviewed by: {{AUTHOR}}_
_Artifact: docs/{{ARTIFACT_TYPE}}/{{FEATURE_NAME}}-{{ARTIFACT_TYPE}}.md_

---

## Instructions

- ✅ = Fully meets criterion
- ⚠️ = Partially meets (details in observations)
- ❌ = Does not meet (blocker for next step)
- N/A = Not applicable to this feature

**Items marked 🔴 are blockers — they prevent advancing to the next pipeline step.**

---

## Section 1 — Clarity and Completeness

| # | Criterion | Status | Observations |
|---|-----------|--------|-------------|
| 1.1 | 🔴 All requirements have unique IDs (RF-NNN / RNF-NNN) | {{STATUS}} | {{OBS}} |
| 1.2 | 🔴 Each RF has Gherkin acceptance criteria (Given/When/Then) | {{STATUS}} | {{OBS}} |
| 1.3 | 🔴 RNFs have measurable metrics (not "be fast", but "< 200ms p95") | {{STATUS}} | {{OBS}} |
| 1.4 | Stakeholders identified with clear responsibilities | {{STATUS}} | {{OBS}} |
| 1.5 | Target audience defined with personas | {{STATUS}} | {{OBS}} |

---

## Section 2 — Internal Consistency

| # | Criterion | Status | Observations |
|---|-----------|--------|-------------|
| 2.1 | 🔴 No contradictions between requirements | {{STATUS}} | {{OBS}} |
| 2.2 | Use cases cover all RFs | {{STATUS}} | {{OBS}} |
| 2.3 | Business rules referenced by RFs that apply them | {{STATUS}} | {{OBS}} |
| 2.4 | Priorities (Must/Should/Could/Won't) assigned to all RFs | {{STATUS}} | {{OBS}} |

---

## Section 3 — Scope and Traceability

| # | Criterion | Status | Observations |
|---|-----------|--------|-------------|
| 3.1 | 🔴 Explicit "Out of Scope" section | {{STATUS}} | {{OBS}} |
| 3.2 | External dependencies listed | {{STATUS}} | {{OBS}} |
| 3.3 | Success KPIs defined and measurable | {{STATUS}} | {{OBS}} |
| 3.4 | Technical or business constraints documented | {{STATUS}} | {{OBS}} |

---

## Section 4 — Readiness for Next Step

| # | Criterion | Status | Observations |
|---|-----------|--------|-------------|
| 4.1 | 🔴 Artifact approved by Product Owner | {{STATUS}} | {{OBS}} |
| 4.2 | Open questions resolved or documented | {{STATUS}} | {{OBS}} |
| 4.3 | Version and date updated in header | {{STATUS}} | {{OBS}} |
| 4.4 | No {{SCREAMING_SNAKE_CASE}} placeholders remaining | {{STATUS}} | {{OBS}} |

---

## Result

| Blockers (🔴) | Improvements (⚠️) | Approved (✅) |
|--------------|-----------------|-------------|
| {{N_BLOCKERS}} | {{N_IMPROVEMENTS}} | {{N_APPROVED}} |

**Decision:** ✅ Approved for next step | ⚠️ Approved with reservations | ❌ Rejected — fix blockers

**General observations:**
{{GENERAL_OBSERVATIONS}}
