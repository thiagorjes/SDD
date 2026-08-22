# Integration Contract — {{SYSTEM_A}} ↔ {{SYSTEM_B}}
_Version: 1.0 | Status: ok | Date: {{DATE}} | Owner: {{OWNER}}_

---

## Identification

| Field | Value |
|-------|-------|
| Interface | {{INTERFACE_NAME}} |
| Direction | {{SYSTEM_A}} → {{SYSTEM_B}} |
| Protocol | REST \| gRPC \| Event \| File \| CLI |
| Owner | {{OWNING_SYSTEM}} |
| Version | 1.0 |

---

## Description

{{INTERFACE_DESCRIPTION}}

---

## Data Contract

### Input

```
{{INPUT_SCHEMA}}
```

**Required fields:**
| Field | Type | Description | Validation |
|-------|------|-------------|------------|
| {{FIELD_1}} | {{TYPE_1}} | {{DESCRIPTION_1}} | {{VALIDATION_1}} |

### Output

```
{{OUTPUT_SCHEMA}}
```

**Response fields:**
| Field | Type | Description | When present |
|-------|------|-------------|-------------|
| {{FIELD_1}} | {{TYPE_1}} | {{DESCRIPTION_1}} | Always |

---

## Errors and Codes

| Code | Meaning | Expected action |
|------|---------|----------------|
| {{CODE_1}} | {{MEANING_1}} | {{ACTION_1}} |

---

## SLAs

- **p95 latency:** {{P95_LATENCY}}
- **Availability:** {{AVAILABILITY}}
- **Retry policy:** {{RETRY_POLICY}}

---

## Examples

### Sample request

```
{{REQUEST_EXAMPLE}}
```

### Sample response

```
{{RESPONSE_EXAMPLE}}
```

---

## Revision History

| Version | Date | Author | Change |
|---------|------|--------|--------|
| 1.0 | {{DATE}} | {{OWNER}} | Initial version |
