# Verde Valley Ventures — Automated Accounting Workbook

Course project for **Accounting Principles**, Dong-A University (Busan, South Korea),
exchange semester 2026.

📊 **[Open the Google Sheet](https://docs.google.com/spreadsheets/d/109SBeSMhQ1WNiSlAAtOwYj2oHl5AEKIt_teOHjO3V58/edit?usp=sharing)**

## The assignment

The course replaces weekly exercises with one large assignment spanning the whole
semester. It hands you a year in the life of a company you have never seen: **120 raw
transactions** for Verde Valley Ventures, a fictional eco-tourism and outdoor
recreation business founded in January 2024, with revenue from equipment rentals,
guided tours, retail and events.

Each transaction is a date, an amount, a free-text description, settlement terms, a
counterparty and a clerk's suggested account — and the clerk is not always right.

The task is to carry all of it through the full accounting cycle, in a single
spreadsheet, and close with a report on what the numbers say about the business. There
is also a deliberate anomaly hidden in the data, which has to be found and argued from
the records themselves.

## What I built

Rather than classifying 120 transactions by hand, the workbook automates the chain
from raw data to financial statements. Nothing is typed twice: every figure downstream
is a formula.

**Rule-based classification.** A `Rules` tab maps keywords found in the transaction
text to debit and credit pairs, with a short note explaining the accounting reasoning
behind each rule. A transaction like *"financed by seller"* resolves to equipment
against cash for the paid portion and equipment against notes payable for the
remainder.

**Regex extraction.** Several amounts are buried in the free-text supporting detail
rather than given as the transaction amount — cost of goods sold, interest inside a
loan payment, fees withheld by a platform, prior deposits applied. `REGEXEXTRACT`
formulas pull these out so the entry can be split correctly.

**Multi-line entries.** Each transaction expands into up to three balanced lines, then
`FILTER` and `FLATTEN` collapse them into a clean journal.

**Downstream statements.** Ledger, trial balance, income statement, retained earnings,
balance sheet and cash flow all read from the journal. Consistency checks run at every
layer.

## Result

```
Revenue                279,500
Cost of goods sold      39,000
Gross profit           240,500
Operating expenses     233,070
Operating income         7,430
Net income               4,730

Total assets           129,230
Total liabilities       74,500
Total equity            54,730

Trial balance    CR = DR         -> BALANCED
Balance sheet    A = L + E       -> BALANCED
```

A first year that is profitable, but barely: net income is 1.7% of revenue, with wages
and rent absorbing most of the gross margin.

## Tabs

| Tab | Purpose |
|---|---|
| `Raw_Data` | The 120 transactions as given |
| `Chart_of_Accounts` | Accounts used, by category |
| `Rules` | Keyword → debit/credit mapping, with reasoning |
| `Entries` | Parsing and expansion into balanced lines |
| `Journal` | The assembled journal |
| `General_Ledger` | T-accounts per account |
| `Trial_Balance` | Balance check before statements |
| `Income_Statement`, `Retained_Earnings`, `Balance_Sheet`, `Cash_Flow_Statement` | Financial statements |
| `Year_End_Report` | Closing analysis of the business |
| `Learning_Report` | Required self-reflection per milestone |

## Tools

Google Sheets — `REGEXEXTRACT`, `FILTER`, `FLATTEN`, `SUMIFS`, `UNIQUE`, `ARRAYFORMULA`.

---

**Filippo Ferrabue** — [filippoferrabue.github.io](https://filippoferrabue.github.io)
