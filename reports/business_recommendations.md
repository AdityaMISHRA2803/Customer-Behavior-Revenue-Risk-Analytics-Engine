# Customer Churn Analysis — Business Recommendations

**Dataset:** IBM Telco Customer Churn (7,043 customers) — [Kaggle: blastchar/telco-customer-churn](https://www.kaggle.com/datasets/blastchar/telco-customer-churn)
**Tools used:** Microsoft Excel, SQL Server, Python (Jupyter), Power BI

---

## Executive Summary

This analysis examined 7,043 telecom customers to identify churn drivers, quantify revenue exposure, and build a predictive model to flag at-risk customers. The company's overall churn rate is **26.5%**, representing **$1,669,570 in annualized recurring revenue at risk**. Findings were independently validated across four tools — Excel, SQL, Python, and Power BI — and consistently point to the same root causes: short-tenure customers on month-to-month contracts, paying by electronic check, without security or support add-ons, churn at dramatically higher rates than the rest of the base. A single compound segment — month-to-month contract, fiber optic internet, electronic check payment — churns at **60.4%** and alone accounts for **$819,378** of the total revenue at risk. A trained classification model can catch roughly half of at-risk customers before they leave, giving the business a concrete tool to act on these findings.

---

## Key Findings

- **Contract type is the strongest single driver of churn.** Month-to-month customers churn at 42.7%, versus 11.3% for one-year contracts and 2.8% for two-year contracts — a 15x gap between the extremes.
- **Tenure and churn are inversely related.** Churn is highest in the first 12 months (47.4%) and drops steadily to 6.6% by year six, indicating the first year is the critical retention window.
- **Fiber optic internet customers churn nearly as much as month-to-month customers** (41.9%), the single largest revenue-at-risk category by service type ($1,371,601).
- **Electronic check is the highest-churn payment method** (45.3%), more than double every other payment method, and carries $1,011,465 in revenue at risk.
- **Lack of security/support add-ons correlates strongly with churn.** Customers without Online Security churn at 41.8% (vs. 14.6% with it); customers without Tech Support churn at 41.6% (vs. 15.2% with it) — roughly a 3x gap in both cases.
- **Senior citizens churn at nearly double the rate of non-seniors** (41.7% vs. 23.6%), a meaningful demographic gap. Gender showed no meaningful difference (26.2% male vs. 26.9% female) and was ruled out as a retention factor.
- **The compound segment of Month-to-month + Fiber optic + Electronic check customers churns at 60.4%** — more than double the company average — and represents the single highest-value retention target at $819,378 in revenue at risk across 1,307 customers.

---

## Retention Recommendations

1. **Prioritize the compound high-risk segment first.** Customers on month-to-month contracts, with fiber optic internet, paying by electronic check, should be the first target for retention outreach — this segment carries the highest churn rate (60.4%) and the largest concentrated revenue exposure of any identifiable group.

2. **Incentivize contract upgrades.** Offer discounts or perks for month-to-month customers to move to one-year or two-year contracts, where churn drops by 4x to 15x. Even partial migration off month-to-month plans would materially reduce total churn.

3. **Build a first-year retention program.** Since nearly half of churn happens in the first 12 months, introduce proactive check-ins, onboarding support, or early-tenure loyalty incentives during a new customer's first year specifically.

4. **Upsell Online Security and Tech Support add-ons.** Customers with these services churn at roughly a third of the rate of those without them. Bundling these add-ons — especially for new and fiber optic customers — is a low-cost, high-leverage retention lever.

5. **Encourage migration away from electronic check payments.** Promote automatic bank transfer or credit card payment as the default, potentially with a small discount incentive, since both show meaningfully lower churn than manual electronic check payments.

6. **Investigate fiber optic service quality or pricing.** Fiber optic churns almost as high as month-to-month contracts and carries the largest single revenue-at-risk figure by service type. This warrants a closer look at fiber-specific pricing, competitor offers, or service satisfaction, which this dataset cannot answer directly (see Limitations).

7. **Add extra retention touchpoints for senior citizens.** Given their near-double churn rate, senior-specific support, simplified billing, or dedicated service channels could meaningfully reduce churn in this group.

8. **Deploy the churn prediction model to flag at-risk customers proactively.** Rather than waiting for churn to happen, use the trained model's monthly predictions to route the highest-risk customers directly to the retention team before they leave.

---

## Prioritized Retention Strategy

**Tier 1 — Immediate action:**
Month-to-month + Fiber optic + Electronic check customers (1,307 customers, 60.4% churn, $819,378 at risk). Smallest customer count, highest concentrated risk — the best return on a focused retention campaign.

**Tier 2 — Near-term action:**
Customers matching any one of the individual high-risk drivers on their own: month-to-month contract, first-year tenure, no security/support add-ons, or electronic check payment, outside of the Tier 1 overlap. Broader reach, still high-impact.

**Tier 3 — Ongoing monitoring:**
Senior citizens and fiber optic customers generally, plus all customers flagged by the predictive model as elevated-risk but not already captured in Tiers 1–2. Lower urgency, but worth systematic tracking.

---

## Model Evaluation Summary

Two classification models were trained and evaluated on a held-out 20% test set (1,409 customers):

| Metric | Logistic Regression | Random Forest |
|---|---|---|
| Accuracy | 80.7% | 80.6% |
| Precision | 65.8% | 66.9% |
| Recall | 56.7% | 53.5% |
| F1-Score | 60.9% | 59.4% |
| ROC-AUC | 0.842 | 0.844 |

The two models perform almost identically overall, but differ in the type of error they make. Logistic Regression missed 162 actual churners in testing (correctly caught 212 of 374); Random Forest missed 174 (correctly caught 200 of 374), while producing fewer false alarms (99 vs. 110).

**Recommended model: Logistic Regression.** In a churn-prevention context, a missed churner represents lost recurring revenue with no chance to intervene, while a false alarm only costs an unnecessary retention offer to a customer who wasn't leaving. Since missing a churner is the more expensive mistake, the model with fewer missed churners is the better business choice, even though Random Forest scored marginally higher on ROC-AUC.

Feature importance analysis (Random Forest) confirmed the same drivers found independently in Excel and SQL: tenure, total/monthly charges, fiber optic internet service, contract length, and electronic check payment were the top predictors of churn.

---

## Limitations & Future Improvements

- **Single point-in-time snapshot.** This dataset has no historical/trend data, so churn drivers could shift over time in ways this analysis can't detect.
- **No cost data for retention offers.** True ROI of any recommendation (e.g., contract-upgrade discounts) can't be calculated without knowing the cost of the incentive versus the revenue saved.
- **No customer satisfaction or complaint data.** The fiber optic churn pattern in particular would benefit from service-quality or NPS data to determine root cause (price vs. reliability vs. competition).
- **Model recall is ~57%,** meaning roughly 43% of actual churners are not flagged in advance. This is a meaningful gap for future model improvement (e.g., additional features, class-balancing techniques, or ensemble methods).
- **Dataset is a public sample from one hypothetical telecom provider**, not proprietary company data — findings demonstrate methodology and are directionally realistic, but would need to be re-validated against a real company's data before being acted on operationally.

---

## Conclusion

This analysis demonstrates a complete, cross-validated churn analytics workflow — from raw data cleaning through predictive modeling and executive-level reporting — using the same core toolset (Excel, SQL, Python, Power BI) found in a modern data analyst role. The findings are consistent and specific: a small, well-defined customer segment accounts for a disproportionate share of revenue risk, and a working retention program targeting contract type, early tenure, service add-ons, and payment method could realistically protect a meaningful share of the $1.67M in total revenue currently at risk — with the top-priority segment alone representing $819,378 of that exposure.
