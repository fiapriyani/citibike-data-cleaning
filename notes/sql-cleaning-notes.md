# SQL Notes: TRIM() and Empty Strings

## Syntax

```sql
TRIM(start_station_name) != ''
```

## Explanation

- `TRIM()` removes leading and trailing spaces from a string.
- `!=` means "not equal to."
- `''` represents an empty string.

This condition keeps rows where `start_station_name` is not empty after leading and trailing spaces are removed.

## Example

| Original Value | After TRIM() | Condition |
|---|---|---|
| `'Central Park S & 6 Ave'` | `'Central Park S & 6 Ave'` | TRUE |
| `''` | `''` | FALSE |
| `'   '` | `''` | FALSE |

## Key Difference

`IS NOT NULL` checks whether a value is not NULL, while `TRIM(column) != ''` checks whether the trimmed string is not empty.

A value can be non-NULL but still contain an empty string.

## Application

In the Citi Bike analysis, this condition filters out trips with missing station names represented by empty strings rather than NULL values.