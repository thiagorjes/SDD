# TechSpec — {{FEATURE_NAME}}
_Version: 1.0 | Status: Draft | Date: {{DATE}} | Author: {{AUTHOR}}_
_PRD: docs/prd/{{FEATURE_NAME}}-prd.md v{{PRD_VERSION}}_

---

## 1. Technical Overview

{{TECHNICAL_DESCRIPTION}}

**Affected systems:** {{AFFECTED_SYSTEMS}}

**Approach:** {{TECHNICAL_APPROACH}}

---

## 2. Architectural Decisions

> Decisions: {{ADR_LIST}}

| ADR | Decision | Impact |
|-----|----------|--------|
| ADR-{{NNN}} | {{DECISION}} | {{IMPACT}} |

---

## 3. Data Model

→ Full document: [data-model.md]({{FEATURE_NAME}}/data-model.md)

**Main entities:**

| Entity | Key attributes | Relationships |
|--------|---------------|--------------|
| {{ENTITY_1}} | {{ATTRIBUTES_1}} | {{RELATIONS_1}} |

---

## 4. API / Interface Contracts

→ Full documents: [contracts/]({{FEATURE_NAME}}/contracts/)

### {{ENDPOINT_OR_INTERFACE_1}}

**Type:** REST | gRPC | Event | File | CLI

**Contract:**
- Input: {{INPUT_DESCRIPTION}}
- Output: {{OUTPUT_DESCRIPTION}}
- Errors: {{ERROR_CODES}}

---

## 5. Architecture and Flow

```
{{ASCII_OR_MERMAID_DIAGRAM}}
```

**Main flow:**
1. {{STEP_1}}
2. {{STEP_2}}
3. {{STEP_3}}

---

## 6. Cross-System Dependencies

| System | Interface | Status | Mock? |
|--------|-----------|--------|-------|
| {{SYSTEM_1}} | {{INTERFACE_1}} | {{STATUS_1}} | No |

---

## 7. Testing Strategy

| Type | Tool | Target coverage |
|------|------|----------------|
| Unit | {{UNIT_TOOL}} | {{UNIT_COVERAGE}} |
| Integration | {{INT_TOOL}} | {{INT_COVERAGE}} |
| E2E | {{E2E_TOOL}} | Main flows |

---

## 8. Security and Observability

**Security:**
- {{SECURITY_CONSIDERATION_1}}

**Observability:**
- Logs: {{LOG_STRATEGY}}
- Metrics: {{KEY_METRICS}}

---

## 9. Traceability Matrix

| RF/RNF | Implemented in | Validated by |
|--------|---------------|-------------|
| RF-001 | {{IMPLEMENTATION_FILE}} | {{VALIDATION_METHOD}} |
| RNF-001 | {{IMPLEMENTATION_FILE}} | {{VALIDATION_METHOD}} |

---

## 10. Open Questions

| # | Question | Owner | Due |
|---|----------|-------|-----|
| Q-001 | {{QUESTION}} | {{OWNER}} | {{DUE}} |

---

## 11. Revision History

| Version | Date | Author | Change |
|---------|------|--------|--------|
| 1.0 | {{DATE}} | {{AUTHOR}} | Initial version |
