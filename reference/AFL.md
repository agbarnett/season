# Australian Football League (AFL) Players' Birthdays for the 2009 Season

The data are: a) the monthly frequencies of birthdays and an expected
number based on monthly birth statistics for 1975 to 1991. b) all 617
players' initials and birthdays (excluding non-Australian born players).

## Usage

``` r
AFL
```

## Format

A list with the following 5 variables:

- month: integer month (1 to 12)

- players: number of players born in each month (12 observations)

- expected: expected number of players born in each month (12
  observations)

- initials: player initials (617 observations)

- dob: date of birth in date format (617 observations; year-month-day
  format)

## Source

Dates of birth from Wikipedia.

## Examples

``` r
# \donttest{
barplot(AFL$players, names.arg=month.abb)

# }
```
