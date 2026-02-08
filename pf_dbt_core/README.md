# pf_dbt_core

This package contains dbt models and related artifacts for the `personal_fin`
project. It focuses on ingesting and transforming raw daily spend data into
clean, deduplicated tables suitable for reporting and downstream analytics.

Structure:
- `models/bq/` — BigQuery models and model-level documentation.

Quick notes:
- Consider adding `schema.yml` files next to models to declare tests and
  documentation that dbt will surface in its docs site.
- When adding or modifying models, run the appropriate dbt commands locally:

```bash
dbt run --models path.to.model
dbt test --models path.to.model
```
Welcome to your new dbt project!

### Using the starter project

Try running the following commands:
- dbt run
- dbt test


### Resources:
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](https://community.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices
