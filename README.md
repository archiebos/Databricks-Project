# Databricks-Project

# Databricks Data Engineering Project

A teaching repository for building a medallion pipeline (Bronze, Silver, Gold) on Databricks Free Edition. It contains a teacher-led example pipeline, the same example rebuilt in dbt, and a worked example using the Finnhub API, which is the data source students will use for their own project.

## Repository structure

```
Databricks-Project/
├── Example Pipeline/   Teacher-led Bronze, Silver and Gold example with student prompts
├── dbt/                The example pipeline rebuilt as a dbt project
├── finnhub/            Worked example of pulling and transforming Finnhub API data
├── LICENSE
└── README.md
```

Adjust the folder names above if yours differ.

## Medallion architecture

Each pipeline moves data through three layers. Every layer reads from the one before it.

| Layer | Purpose | Example |
|---|---|---|
| Bronze | Raw data exactly as it arrived, with ingestion metadata. Nothing is parsed or cleaned. | The full JSON response stored as a single string |
| Silver | Parsed, typed and de-duplicated data. | One row per news article, with real column types and dates |
| Gold | Business-ready tables built for analysis. | News per symbol with story counts and the number of days covered |

## Example Pipeline

A worked Bronze, Silver and Gold example for the teacher to run through with the class. The notebooks are deliberately incomplete and contain prompts that guide students. During the session, the teacher adds the code from the walkthrough script (kept in a Google Doc) into the Bronze, Silver and Gold files, one layer at a time.

## dbt

The same example pipeline, connected to dbt and restructured into the standard dbt layout:

| dbt layer | Broadly corresponds to |
|---|---|
| `models/staging` | Bronze: light cleaning of the raw data |
| `models/intermediate` | Silver: transformation and joining |
| `models/marts` | Gold: tables ready for analysis |

The folder also holds the usual dbt directories: `macros`, `seeds`, `snapshots`, `tests` and `analyses`. Run dbt commands from inside the `dbt` folder, or pass `--project-dir dbt`. You need your own dbt connection profile for your workspace. Do not commit credentials.

## Finnhub example

Example code showing how the Finnhub API can be used. Students will build their own project on this API, so this is a sketch and not a full solution.

What it demonstrates:

- **Bronze:** call an endpoint (company news and basic financials) for a ticker symbol and append the raw JSON, as a string, to a Delta table together with the symbol, endpoint, status code and ingestion time.
- **Silver:** parse the JSON with `from_json`, expand arrays with `explode`, convert Unix timestamps to dates and remove duplicate articles.
- **Gold:** keep one row per article and add summary columns per symbol, such as the total number of stories and the number of days between the first and last article.

How it is set up:

- The ticker symbol is a notebook widget, so a Databricks Job can pass it in as a Job parameter. Running it for a second symbol appends to the same tables.
- The API key is read from a Databricks secret and never appears in a notebook.
- Tables live in the `workspace` catalog, in the `bronze`, `silver` and `gold` schemas.
- A Databricks Job runs Bronze, then Silver, then Gold as dependent tasks.

Data freshness differs by endpoint. Quotes and news change through the day, so they suit frequent polling. Fundamentals only change when a company files results, so a daily run is enough.

## Databricks Free Edition notes

- Compute is serverless only, and usage quotas apply across the account. Stop anything you are not using, and avoid scheduling jobs more often than you need.
- Materialized views need a SQL warehouse and do not run on the general serverless compute used by notebooks. The examples use ordinary Delta tables refreshed with `INSERT OVERWRITE` instead.
- Jobs are limited to 5 concurrent tasks per account.
- The free Finnhub tier allows 60 API calls per minute.

## Security

- Never put API keys or tokens in notebooks, in committed files or in screenshots.
- If a key is exposed, regenerate it in the provider's dashboard and store the new one.
