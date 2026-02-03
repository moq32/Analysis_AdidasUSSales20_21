<div align="center">

# 👟 Adidas US Sales (2020–2021) — SQL Analytics Project

A SQL-driven analysis of Adidas retail sales across the United States (2020–2021) to understand COVID-era impact and identify trends by **region, retailer, sales method, product type, and gender**.  
Python was used **only for visualizations** (charts) after extracting/aggregating data with SQL.

<!-- Optional badges -->
![SQL](https://img.shields.io/badge/SQL-Primary%20Analysis-111827)
![Python](https://img.shields.io/badge/Python-Visualization%20Only-3776AB?logo=python&logoColor=white)
![Focus](https://img.shields.io/badge/Focus-COVID%20Impact%20%7C%20Retail%20Trends-0EA5E9)

</div>

---

## ✨ Project goals
- Compare Adidas sales performance across **2020 vs 2021** (COVID disruption vs recovery).
- Identify trends across:
  - 🌎 Region / State / City
  - 🏪 Retailer
  - 🛒 Sales method (in-store, online, outlet, etc.)
  - 📦 Product categories
  - 👥 Gender segments
- Evaluate performance using: total sales, operating profit, units sold, operating margin, and pricing.

---

## 🧾 Dataset overview
Each row represents a transaction-level sales record with:

- `Retailer`, `Retailer ID`
- `Invoice Date`
- `Region`, `State`, `City`
- `Product`
- `Price per Unit`
- `Units Sold`
- `Total Sales`
- `Operating Profit`
- `Operating Margin`
- `Sales Method`

---

## 🧱 Dataset
> Adjust names to match your database.

**DataFile:** `Adidas.sql`
**Table:** `adidasussales`

Recommended column types:
- `invoice_date` DATE
- `price_per_unit` NUMERIC
- `units_sold` INT
- `total_sales` NUMERIC
- `operating_margin` NUMERIC
- `operating_profit` NUMERIC
- Other dimensions as TEXT/VARCHAR: retailer, region, state, city, product, sales_method

---

## 🧹 Data cleaning & preparation (SQL-first)
Key preparation tasks:
- Standardize column naming (snake_case) for easier querying.
- Ensure `invoice_date` is a true DATE type (fix mixed date formats during load/ETL).
- Validate numeric types (no text in numeric fields).
- Validate/compute derived metrics:
  - `total_sales = price_per_unit * units_sold`
  - `operating_profit = total_sales * operating_margin`

---

## 🧠 Analysis roadmap (SQL)
Below are the core analysis themes implemented via SQL aggregations and comparisons.

### 1) 🌎 Regional performance (2020 vs 2021)
Questions answered:
- Which regions grew the most in total sales, profit, and units sold?
- Does unit volume always align with revenue?

Typical outputs:
- Total units sold by region/year
- Total sales by region/year
- Operating profit by region/year

### 2) 🏪 Retailer performance
Questions answered:
- Which retailers drove the most revenue/profit in each year?
- How do units sold relate to revenue by retailer?

Typical outputs:
- Revenue by retailer/year
- Units sold vs revenue extract for scatter plot

### 3) 🛒 Sales method & pricing
Questions answered:
- How did channel performance shift (e.g., online vs in-store)?
- Did the average price per unit change year-over-year?

Typical outputs:
- Total sales & operating profit by sales method/year
- Avg price per unit by sales method/year

### 4) 📦 Product trends
Questions answered:
- Which product categories increased/decreased in sales and profit?
- How did pricing and units sold distributions shift across years?

Typical outputs:
- Price-per-unit distribution extract by product/year (for box plots)
- Units sold & operating profit summary by product/year

### 5) 👥 Gender-based segmentation
Questions answered:
- How did men vs women revenue compare in 2020 vs 2021?
- Apparel vs footwear breakdown by gender and year

Typical outputs:
- Revenue by gender/year
- Revenue by gender × category (apparel/footwear) × year

---

## 📌 Key insights (from the report narrative)
- 2021 shows a strong rebound vs 2020 across regions/retailers/channels (COVID vs recovery context).
- The West region is consistently a top performer.
- Online sales shift is significant and appears structural; e-commerce capability is critical.
- Mid-price ranges tend to produce the highest profits due to volume; extreme low/high pricing doesn’t guarantee profit.
- Footwear dominates apparel in revenue across genders; women’s footwear demand may be an opportunity area.

---

## 📊 Visualizations (Python only)
Python was used to visualize SQL outputs (e.g., bar charts, scatter plots, box plots, pie charts).

---

## 🧩 Obstacles
Common challenges addressed:
- Mixed invoice date formats (fixed during load/standardization)
- Choosing the right visualizations to support SQL findings
- Keeping SQL + visualization outputs consistent and reproducible

---

## 🤖 AI disclosure
AI tools were used to:
- Suggest charting code for visualizations
- Help debug datatype and coding issues
- Explain errors to speed up iteration

---

## ✅ Conclusion
This SQL-first analysis highlights how Adidas sales patterns shifted from 2020 to 2021 and provides decision-ready insights across region, retailer performance, channel shifts, product dynamics, and gender segmentation.
