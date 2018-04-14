This R script has been created to simulate the possible outcomes of baskets of index mutual funds based on asset allocations. The asset classes are:
  Large Caps: S&P500 (large_cap_weight). - A number between 0 and 1. ex: input 0.5 for 50% 
  Small Caps: Russell 600(small_cap_weight). - A number between 0 and 1.
  International Large Caps:  MSCI EAFE (international_weight). - A number between 0 and 1.
  US Government Bonds: (bond_weight). - A number between 0 and 1.
  Bank Accounts: (CD_weight). - A number between 0 and 1.

The sum of all asset weights should be one (1).

The model allows for the saver to input
  The number of years they have for retirement (save_time) - An integer in years.
  The yearly contributions to their retirement fund (save_add) - An integer in years.
  The fractional yearly increase in retirement savings (save_add_increase_percent) - A number between 0 and 1. Ex: 0.03 is 3%.
  The amount of time you expect to live in retirement (retire_time) - in years.
  The amount of money you will need in retirement to cover your living expenses (cost_of_living) - in today's dollars.
  The amount of money you have already saved in your retirement account (initial_capital) - in dollars.

Two parameters that the user needs to set:
  The inflation adjustment (account_for_inflation) - TRUE or FALSE (all caps)
  The number of simulations. I suggest 1000 for statistical relevance, however more simulations require more time to complete the script. - A positive integer


The outcomes of the simulations are based on annual market data for the years since 1980. Simulations are constructed based on a bootstrap (selection with replacement) method.

Outcomes are charted on the following criteria:
  Median performance of a retirement fund.
  Chance of completing retirement with a non-zero balance.
  Value of portfolio based on market Performance. Perfomance criteria (Good-75th Percentile; Fair-50th Percentile; Poor - 25th Percentile)
  
