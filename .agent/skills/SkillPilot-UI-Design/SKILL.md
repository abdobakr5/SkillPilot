---
name: SkillPilot-UI-Design
description: Enforces the SkillPilot dark, premium developer design system, glassmorphism, typography, and styling rules on every generated Flutter UI.
triggers:
  - "build ui"
  - "design screen"
  - "apply design"
  - "create screen"
  - "implement screen"
---

# SkillPilot UI Design System & Styling Rules

All UI components, views, layouts, and screens built for the **SkillPilot** platform MUST strictly follow the design specifications outlined below.

---

## 1. General Vibe & Constraints
- **Vibe**: Dark, Elegant, Modern, Tech-Savvy, Premium, Glassmorphism tailored for developers.
- **Language**: All UI text, titles, labels, placeholders, tooltips, and helper texts must be entirely in **English**.
- **Geometry**: Strict border radius of **6px to 8px** across cards, inputs, and dialogs.
- **Grid & Spacing**: Strict adherence to an 8pt grid system (8px, 16px, 24px, 32px, 48px).

---

## 2. Color Palette Tokens (`AppColors`)
Reference all colors directly from `core/theme/app_colors.dart`:
- **Background**: `#0D1117` (Deep Navy / Charcoal Black)
- **Cards / Surface**: `#161B22` (Elevated Dark Gray)
- **Primary Accent**: `#A855F7` (Vibrant Purple)
- **Secondary Accent**: `#FBBF24` (Bright Amber / Gold)
- **Tertiary Accent**: `#F43F5E` (Vivid Coral)
- **Primary Text**: `#E6EDF3` (Crisp Off-White)
- **Secondary Text**: `#8B949E` (Muted Cool Gray)
- **Borders & Dividers**: `#30363D` (Subtle Dark Gray)
- **Hover / Glow**: Platinum border `#E5E7EB` with subtle ambient glow shadow.

---

## 3. Typography Hierarchy (`AppTextStyles`)
- **Primary Font**: `Inter` or `Roboto` for clean readability.
- **Code Snippets Font**: `JetBrains Mono` or `Fira Code`.
- **Sizes**:
  - `H1`: 32px Bold (`AppTextStyles.h1`)
  - `H2`: 24px SemiBold (`AppTextStyles.h2`)
  - `Body`: 16px Regular (`AppTextStyles.body`)
  - `Body Secondary`: 14px Regular (`AppTextStyles.bodySecondary`)
  - `Code Blocks`: 13px Monospace (`AppTextStyles.code`)

---

## 4. Components & Interactive Patterns

### A. Ambient Glassmorphism & Background Blobs
- Use `Stack` layouts to place ambient blur blobs behind the content:
  - Rich purple (`0x66A855F7`) and deep navy background blur layers.
  - High blur radius (`ImageFiltered` or `BackdropFilter` with `sigmaX: 80, sigmaY: 80+`).

### B. Cards & Hover Effects
- Cards must feature background `#161B22` and border `#30363D` with radius `8px`.
- On desktop/web or tap states, animate to a sleek platinum/silver border (`#E5E7EB`) with ambient glow shadow.

### C. Buttons
- Height: Fixed **44px to 48px** for comfortable touch targets.
- Solid background: Primary purple (`#A855F7`), white text, 8px radius.
- Outlined buttons: `#30363D` border, off-white text, transparent background.

### D. Inputs & Form Fields
- Background `#161B22`, subtle borders `#30363D`, focused border `#A855F7`.
- Always include clear error states (highlighted with `#F43F5E`) and interactive visibility toggles for passwords.

### E. Iconography
- Minimalist, thin outline icons (Phosphor, Lucide, or Feather style).

---

## 5. Execution Rules for Screen Generation
1. Always import and reuse `AppColors`, `AppTextStyles`, and components from `core/theme/` and `core/widgets/`.
2. Wrap forms inside centered, responsive cards with subtle glassmorphic styling.
3. Break the UI into reusable widgets inside `features/<feature_name>/presentation/widgets/`.