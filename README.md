# prop_interact
This function performs an interaction test for proportional outcome data. The joint Null hypothesis is that the difference in proportions between *2* groups is equal across all *k* subgroups (i.e., outcome data is required for all *2 x k* combinations of the two predictors). All *2 x k* proportions as well as differences in proportions for each subgroup *k* are returned and an overall p-value of interaction is calculated. The employed test statistic approximately follows a Chi-squared distribution and was described in:

+ Marascuilo, L. A. (1970). Extensions of the significance test for one-parameter signal detection hypotheses. *Psychometrika*, 35(2), 237-243.

The function replaces the standard Wald variance estimator for binomials, which has weaknesses in particular for proportions close to 0 or 1, by a variance estimator that is based on the Wilson score confidence interval (but standard variance can be used as well):

+ Wilson, E. B. (1927). Probable inference, the law of succession, and statistical inference. *Journal of the American Statistical Association*, 22(158), 209-212.

For more details on the characteristics and calculation of different confidence intervals for proportions see:

+ Brown, L. D., Cai, T. T., & DasGupta, A. (2001). Interval estimation for a binomial proportion. *Statistical science*, 101-117.

An accessible explanation for the test provided by this function, along with a detailed example is available by:

+ Michael, G. A. (2007). A significance test of interaction in 2xK designs with proportions. *Tutorials in Quantitative Methods for Psychology*, 3(1), 1-7.

For feedback, suggestions and errors, please contact *stefan-gehrig[at]t-online.de*.
