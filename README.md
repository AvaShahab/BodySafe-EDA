# BodySafe-EDA

**Exploratory Data Analysis and Inferential Statistics**
Toronto BodySafe Public Health Inspections


---

## About the Dataset

This project analyzes the Toronto BodySafe Public Health Inspection dataset,
sourced from the City of Toronto Open Data Portal. The BodySafe program is
administered by Toronto Public Health and regulates personal service settings
(PSS) such as hair salons, nail studios, tattoo parlours, body piercing
establishments, aesthetics clinics, and micropigmentation studios operating
within the City of Toronto.

These establishments are inspected under **Ontario Regulation 136/18** of the
Health Protection and Promotion Act, covering ten regulated categories including
equipment sterilization, hygiene, record-keeping, and sanitary conditions.

- **Total records:** 11,915 inspection records
- **Time period:** April 2022 – April 2026
- **Original format:** GeoJSON (converted to CSV for analysis)
- **Columns after cleaning:** 14 fields

---

## Project Files

| File | Description |
|------|-------------|
| `Shahabdehkordi_ProjectMileston1 and 2.R` | Full R script — EDA and hypothesis testing |
| `BodySafe_EDA_Report.docx` | Milestone 1 — Exploratory Data Analysis report |
| `Shahabdehkordi_Milestone2_Report.docx` | Milestone 2 — Inferential Statistics report |
| `.gitignore` | R-specific gitignore |

---

## Milestone 1 — Exploratory Data Analysis

### Data Cleaning Steps
- Converted `insDate` from character string to R `Date` class
- Replaced `"None"` strings with proper `NA` values across 5 columns:
  `observation`, `infCategory`, `defDesc`, `infType`, `actionDesc`
- Dropped 3 fully empty columns: `OutcomeDate`, `OutcomeDesc`, `fineAmount`
- Converted `insStatus`, `srvType`, `infType`, `infCategory` to factor type
- Extracted `year` and `month` features from the date column
- Confirmed zero duplicate rows

### Inspection Outcomes

| Outcome | Count | Percentage |
|---------|-------|------------|
| Pass | 9,267 | 77.78% |
| Conditional Pass | 2,451 | 20.57% |
| Closed | 197 | 1.65% |

Roughly **1 in 5 inspections** identified a public health violation.

### Compliance Rate by Service Type

| Service Type | Total | Pass Rate | Closure Rate |
|-------------|-------|-----------|--------------|
| Barbering & Hairdressing | 3,651 | 85.2% | 0.7% |
| Ear Piercing | 184 | 84.8% | 0.0% |
| Aesthetics | 3,772 | 79.1% | 1.1% |
| Micropigmentation/Microblading | 393 | 75.1% | 4.8% |
| Tattooing | 693 | 71.1% | 2.6% |
| Nails | 2,835 | 69.9% | 1.9% |
| Injectable Personal Services | 96 | 66.7% | 2.1% |
| **Body Piercing** | 291 | **62.9%** | **13.1%** |

**Body Piercing** had the lowest pass rate and highest closure rate of any
service type — a critical public health finding given its bloodborne pathogen
transmission risk.

### Top Infraction Categories

| Rank | Category | Count |
|------|----------|-------|
| 1 | 04 - Reprocessing and Maintenance of Reusable Equipment | 1,155 |
| 2 | 02 - General Setting Requirements | 336 |
| 3 | 05 - Single-Use Equipment & Instruments | 261 |
| 4 | 09 - Additional Record Requirements | 202 |
| 5 | 01 - Public Health Notification | 154 |

Category 04 alone accounted for **44.2% of all violations** — nearly 4× more
than the second-ranked category. Improperly reprocessed equipment is the
primary vehicle for transmitting hepatitis B, hepatitis C, MRSA, and fungal
infections between clients.

### Infraction Severity
Of 2,616 total infractions:
- **83.4% were Crucial** — the most severe level under Ontario law
- Only 16.6% were Significant

When violations are found, they are overwhelmingly of the most dangerous type.

### High-Risk vs. Lower-Risk Services

| Risk Group | Pass Rate | Closure Rate |
|-----------|-----------|--------------|
| High-Risk (tattooing, piercing, micropigmentation, injectables) | 70.3% | 5.2% |
| Lower-Risk (hair, nails, aesthetics, ear piercing) | 78.8% | 1.1% |

High-risk establishments had a closure rate **nearly 5× higher** than
lower-risk services.

### Temporal Trends
- 2022 had only 83 records — early-stage program following pandemic disruptions
- Inspection volume grew to 4,691 records in 2025
- A notable spike in late 2025 (800+ monthly inspections) suggests a
  year-end enforcement campaign by Toronto Public Health

### Repeat Offenders
- **LA Galeria Ink** (Tattooing) led with 23 non-compliant inspections
- **YES Electric Tattoo** appeared multiple times across Tattooing, Body
  Piercing, and Barbering categories, indicating chronic systemic non-compliance

---

## Milestone 2 — Hypothesis Testing

All five tests used **α = 0.05** and were conducted using `prop.test()` in R.

---

### Test 1 — Non-Compliance Rate vs. 20% Benchmark *(One-Sample)*

> Is the true non-compliance rate significantly different from 20%?

- **H₀:** p = 0.20 | **Hₐ:** p ≠ 0.20
- Sample: 2,648 non-compliant out of 11,915 → **22.22%**
- X² = 36.836 | p-value = **1.285e-09** | 95% CI: [0.2149, 0.2298]
- ✅ **Reject H₀** — The non-compliance rate is significantly above 20%

---

### Test 2 — High-Risk vs. Lower-Risk Services *(Two-Sample)*

> Do skin-penetrating services fail more often than lower-risk services?

- **H₀:** p₁ = p₂ | **Hₐ:** p₁ > p₂
- High-risk: **29.74%** non-compliance | Lower-risk: **21.16%**
- X² = 54.86 | p-value = **6.471e-14**
- ✅ **Reject H₀** — High-risk services fail at a significantly higher rate
  (~8.6 percentage point gap)

---

### Test 3 — Crucial Infractions: Body Piercing vs. Nails *(Two-Sample)*

> Does Body Piercing have more Crucial infractions than Nails?

- **H₀:** p₁ = p₂ | **Hₐ:** p₁ > p₂
- Body Piercing: **95.37%** Crucial | Nails: **93.05%** Crucial
- X² = 0.817 | p-value = **0.183**
- ❌ **Fail to Reject H₀** — No significant difference found.
  However, both rates exceed 93%, meaning violations in either category
  are almost universally the most dangerous type.

---

### Test 4 — Proportion of Crucial Infractions vs. 80% *(One-Sample)*

> Is the true Crucial infraction rate significantly above 80%?

- **H₀:** p = 0.80 | **Hₐ:** p ≠ 0.80
- Sample: 2,182 Crucial out of 2,616 → **83.41%**
- X² = 19.01 | p-value = **1.301e-05** | 95% CI: [0.8194, 0.8479]
- ✅ **Reject H₀** — The Crucial infraction rate is significantly above 80%

---

### Test 5 — Tattooing vs. Barbering & Hairdressing *(Two-Sample)*

> Does Tattooing fail inspections more than Barbering & Hairdressing?

- **H₀:** p₁ = p₂ | **Hₐ:** p₁ > p₂
- Tattooing: **28.86%** | Barbering & Hairdressing: **14.85%**
- X² = 80.772 | p-value = **< 2.2e-16**
- ✅ **Reject H₀** — Tattoo shops fail nearly **twice as often** as hair
  salons (~14 percentage point gap)

---

### Summary of All Tests

| Test | Type | Question | p-value | Result |
|------|------|----------|---------|--------|
| 1 | One-Sample | Non-compliance ≠ 20%? | 1.285e-09 | ✅ Significant |
| 2 | Two-Sample | High-risk > Lower-risk? | 6.471e-14 | ✅ Significant |
| 3 | Two-Sample | Body Piercing > Nails Crucial? | 0.183 | ❌ Not Significant |
| 4 | One-Sample | Crucial infractions ≠ 80%? | 1.301e-05 | ✅ Significant |
| 5 | Two-Sample | Tattooing > Barbering? | < 2.2e-16 | ✅ Significant |

---

## Conclusion

4 out of 5 hypothesis tests confirmed statistically significant results.
The evidence strongly supports that **skin-penetrating services** have worse
compliance outcomes than lower-risk services, and that violations across the
sector are overwhelmingly of the most severe Crucial classification.

**Policy recommendation:** Toronto Public Health should prioritize inspection
frequency and enforcement resources toward tattooing, body piercing,
micropigmentation, and injectable personal service establishments, where
infection transmission risk is highest and compliance outcomes are
consistently worse.

---

## Tools & Libraries

**R packages:** `tidyverse`, `lubridate`, `ggplot2`, `scales`, `ggthemes`, `knitr`

---

## Data Source

City of Toronto. (2024). *BodySafe: Personal service settings inspection
results* [Data set]. Toronto Open Data Portal.
https://open.toronto.ca/dataset/bodysafe/
