# 02. Analyzing Popular Citi Bike Routes

## Objective

Identify the most popular Citi Bike routes by user type and calculate their average trip duration.

## Step 1: Initial Query

The initial query was designed to identify the most popular routes. However, the results included an unexpected row with a route displayed as `to`, a very high trip count, and a `NULL` average duration.

```sql
-- Initial query: Analyze the most popular Citi Bike routes.

SELECT
  usertype,
  CONCAT(start_station_name, 'to', end_station_name) AS route,
  COUNT(*) AS num_trips,
  ROUND(AVG(tripduration / 60), 2) AS duration
FROM `bigquery-public-data.new_york_citibike.citibike_trips`
GROUP BY
  start_station_name,
  end_station_name,
  usertype
ORDER BY
  num_trips DESC;
```

## Step 2: Investigating Missing and Empty Values

To investigate the unexpected results, I checked the total number of rows and counted the `NULL` and empty values in the relevant columns.

```sql
SELECT
  COUNT(*) AS total_rows,
  COUNTIF(usertype IS NULL) AS null_usertype,
  COUNTIF(start_station_name IS NULL) AS null_start_station,
  COUNTIF(end_station_name IS NULL) AS null_end_station,
  COUNTIF(tripduration IS NULL) AS null_tripduration,
  COUNTIF(start_station_name = '') AS empty_start_station,
  COUNTIF(end_station_name = '') AS empty_end_station
FROM `bigquery-public-data.new_york_citibike.citibike_trips`;
```

### Investigation Results

| Metric | Result |
|---|---:|
| Total rows | 58,937,715 |
| NULL usertype | 0 |
| NULL start station | 0 |
| NULL end station | 0 |
| NULL tripduration | 5,828,994 |
| Empty start station | 5,828,994 |
| Empty end station | 5,828,994 |

The results showed that 5,828,994 rows had a missing trip duration and empty start and end station names. These values explained why the initial query returned an unexpected route labeled `to` and a `NULL` average duration.

## Step 3: Revised Query

I revised the query by excluding rows with empty station names and missing trip durations. I also added spaces around `to` to improve route readability and limited the output to the top 10 results.

```sql
SELECT
  usertype,
  CONCAT(
    start_station_name,
    ' to ',
    end_station_name
  ) AS route,
  COUNT(*) AS num_trips,
  ROUND(AVG(tripduration / 60), 2) AS duration
FROM `bigquery-public-data.new_york_citibike.citibike_trips`
WHERE TRIM(start_station_name) != ''
  AND TRIM(end_station_name) != ''
  AND tripduration IS NOT NULL
GROUP BY
  usertype,
  start_station_name,
  end_station_name
ORDER BY
  num_trips DESC
LIMIT 10;
```

## Key Learnings

- `COUNTIF()` can be used in BigQuery to count rows that meet a specified condition.
- `IS NULL` identifies missing values, while `= ''` identifies empty strings.
- `TRIM()` helps handle values containing only whitespace.
- `WHERE` filters rows before aggregation.
- `GROUP BY` groups trips by user type and station pair.
- `AVG()` calculates the average trip duration, while `ROUND()` controls decimal precision.
- Investigating unexpected query results is an important part of data analysis.


### Investigation Conclusion

The combined check confirmed that 5,828,994 rows had both empty start and end station names and a `NULL` trip duration.

These rows caused the unexpected `to` route and `NULL` average duration in the initial query. I excluded them from the revised analysis to focus on trips with available station names and trip duration data.
