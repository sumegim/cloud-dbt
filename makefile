run:
	@dbt run --profile=dbt-bq --profiles-dir=.
	@dbt test --profile=dbt-bq --profiles-dir=.