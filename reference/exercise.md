# Exercise Data from Queensland, 2005–2007

Exercise data in longitudinal format from a physical activity
intervention study in Logan, Queensland. Some subjects were lost to
follow-up, so all three visits are not available for all subjects.

## Usage

``` r
exercise
```

## Format

A data frame with 1302 observations on the following 7 variables:

- id: subject number

- visit: visit number (1, 2 or 3)

- date: date of interview (year-month-day)

- year: year of interview

- month: month of interview

- bmi: body mass index at visit 1 (kg/m\\^2\\)

- walking: walking time per week (in minutes) at each visit

## Source

From Prof Elizabeth Eakin and colleagues, The University of Queensland,
Brisbane.

## References

Eakin E, et al (2009) Telephone counselling for physical activity and
diet in type 2 diabetes and hypertension, *Am J of Prev Med*, vol 36,
pages 142–9

## Examples

``` r

boxplot(exercise$walking ~ exercise$month)

```
