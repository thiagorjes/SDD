# Design Brief — {{FEATURE_NAME}}
_Version: 1.0 | Date: {{DATE}} | Designer: {{AUTHOR}}_
_PRD: docs/prd/{{FEATURE_NAME}}-prd.md_

---

## 1. Context and Goal

**Feature:** {{FEATURE_NAME}}
**UX goal:** {{UX_GOAL}}
**Target audience:** {{TARGET_AUDIENCE}}

---

## 2. Color Tokens

| Token | Value | Usage |
|-------|-------|-------|
| `--color-primary` | `{{PRIMARY_COLOR}}` | Primary actions, CTAs |
| `--color-secondary` | `{{SECONDARY_COLOR}}` | Secondary actions |
| `--color-background` | `{{BACKGROUND_COLOR}}` | Page background |
| `--color-surface` | `{{SURFACE_COLOR}}` | Cards, modals |
| `--color-error` | `{{ERROR_COLOR}}` | Error states |
| `--color-success` | `{{SUCCESS_COLOR}}` | Success states |
| `--color-text-primary` | `{{PRIMARY_TEXT_COLOR}}` | Main text |
| `--color-text-secondary` | `{{SECONDARY_TEXT_COLOR}}` | Auxiliary text |

---

## 3. Typography

| Token | Font | Weight | Size | Usage |
|-------|------|--------|------|-------|
| `--font-heading-1` | {{HEADING_FONT}} | Bold (700) | {{H1_SIZE}} | Page titles |
| `--font-heading-2` | {{HEADING_FONT}} | SemiBold (600) | {{H2_SIZE}} | Section subtitles |
| `--font-body` | {{BODY_FONT}} | Regular (400) | {{BODY_SIZE}} | Body text |
| `--font-caption` | {{BODY_FONT}} | Regular (400) | {{CAPTION_SIZE}} | Captions, metadata |
| `--font-code` | {{MONO_FONT}} | Regular (400) | {{CODE_SIZE}} | Inline code |

---

## 4. Spacing and Grid

- **Grid:** {{GRID_TYPE}} (e.g.: 12 columns, gutter {{GUTTER}})
- **Breakpoints:** Mobile {{MOBILE_BP}} | Tablet {{TABLET_BP}} | Desktop {{DESKTOP_BP}}
- **Spacing scale:** base {{BASE_SPACING}} (4px or 8px recommended)

| Token | Value | Usage |
|-------|-------|-------|
| `--spacing-xs` | {{SPACING_XS}} | Compact inner elements |
| `--spacing-sm` | {{SPACING_SM}} | Component padding |
| `--spacing-md` | {{SPACING_MD}} | Between components |
| `--spacing-lg` | {{SPACING_LG}} | Page sections |
| `--spacing-xl` | {{SPACING_XL}} | Layout margins |

---

## 5. Components

### {{COMPONENT_1}}

**When to use:** {{WHEN_TO_USE_1}}

**Variants:**
- {{VARIANT_1}}: {{VARIANT_DESCRIPTION_1}}
- {{VARIANT_2}}: {{VARIANT_DESCRIPTION_2}}

**States:** default | hover | active | disabled | loading | error

**Example:**
```
{{COMPONENT_1_EXAMPLE}}
```

---

## 6. Interaction Patterns

| Pattern | Description | Animation |
|---------|-------------|-----------|
| {{PATTERN_1}} | {{PATTERN_DESCRIPTION_1}} | {{ANIMATION_1}} |

**Visual feedback:**
- Success: {{SUCCESS_FEEDBACK}}
- Error: {{ERROR_FEEDBACK}}
- Loading: {{LOADING_FEEDBACK}}

---

## 7. Accessibility

- **Minimum contrast:** WCAG AA (4.5:1 normal text, 3:1 large text)
- **Visible focus:** {{FOCUS_STYLE}}
- **Screen readers:** {{ARIA_CONSIDERATIONS}}
- **Minimum touch target:** 44×44px (mobile)

---

## 8. Design Decision Records (DDR)

| DDR | Decision |
|-----|---------|
| DDR-{{NNN}} | {{DESIGN_DECISION_1}} |

---

## 9. References

- Base design system: {{DESIGN_SYSTEM_LINK}}
- Figma/Prototype: {{PROTOTYPE_LINK}}
- Visual inspiration: {{VISUAL_REFERENCES}}
