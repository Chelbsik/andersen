TASK 02
-----------------------------------------------------------------------------
financial_guru.sh

- Filters quotes.json data and produces tuple of date and quote for EUR/RUB.
- Cuts out quotes for every March from 2015.
- Calculates volatility for every year March.
- Finally, chooses and prints year with least volatile March.

UPDATED 09.03.2021:

- Now script can take year gap as first two parameters (./financial_guru.sh "starting year" "ending year")
- And month as third parameter (./financial_guru.sh "starting year" "ending year" "Mon")
- For correct work all three parameters must be specified
- Month must be in abbreviate format (three first letters, first one is capital: "Jan", "Jul", "Sep", etc.)
-----------------------------------------------------------------------------
no_pattern_matching.sh

- Filters quotes.json data and produces all quotes values in list.
-----------------------------------------------------------------------------

