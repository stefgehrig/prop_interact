# prop_interact

This repository contains two R functions **prop_interact()** and **prop_interact_power()**. 

## prop_interact()

This function performs an interaction test for proportional outcome data using the method described by Marascuilo (1970). The joint Null hypothesis is that the difference in proportions between *2* groups (e.g., treatment and control) is equal across all *k* subgroups (e.g., people with diabetes type I, people with diabetes type II and people without diabetes). Binary individual-level outcome data is required for all *2 x k* combinations of the two categorical predictors (but the function can easily be modified to run on aggregated data, i.e., *2 x k* contintency tables, directly).

All *2 x k* proportions as well as differences in proportions for each subgroup *k* are returned and an overall p-value for the test of interaction is calculated. The employed test statistic approximately follows a Chi-squared distribution and was described in:

+ Marascuilo, L. A. (1970). Extensions of the significance test for one-parameter signal detection hypotheses. *Psychometrika*, 35(2), 237-243.

By default, the function replaces the standard Wald variance estimator for binomials, which has weaknesses in particular for proportions close to 0 or 1, by a variance estimator that is based on the Wilson score confidence interval (but Wald variance can be used as well):^[The variance estimator based on the score interval is a weighted average of the variance of the actually observed proportion and the variance at p = 1/2, with a standard normal z-quantile determining the weight put on the latter (Agresti & Coull, 1998). The function presented here uses the 0.975-quantile (z = 1.96) for variance estimation, as one would when constructing a 95% Wilson score interval. The choice captures the intuition that we assign a rather low "typicalness" (see Wilson, 1927, p. 211) to the observed proportion (specifically, a "typicalness" of 5 in 100), allowing the estimate of the true proportion to be considerably shrunk towards p = 1/2, and hence its variance to be shrunk towards the variance of p = 1/2. Note that his variance estimator approximates the Wald variance for large N and is equal to it for z = 0 (i.e., full "typicalness").]

+ Wilson, E. B. (1927). Probable inference, the law of succession, and statistical inference. *Journal of the American Statistical Association*, 22(158), 209-212.

For more details on the characteristics and calculation of different confidence intervals (and the variance estimates they are based on) for proportions, see:

+ Brown, L. D., Cai, T. T., & DasGupta, A. (2001). Interval estimation for a binomial proportion. *Statistical science*, 101-117.

+ Agresti, A., & Coull, B. A. (1998). Approximate is better than “exact” for interval estimation of binomial proportions. *The American Statistician*, 52(2), 119-126.

An accessible explanation for the statistical test provided by the function in this repository, along with a detailed example is available by:

+ Michael, G. A. (2007). A significance test of interaction in 2xK designs with proportions. *Tutorials in Quantitative Methods for Psychology*, 3(1), 1-7.

Note that the approach is conceptually related to significance testing of interaction terms in logistic regression via likelihood ratio tests. It leads to similar inferences without explicitly employing a generalized linear modelling framework.

## prop_interact_power()

This function analyzes the statistical power of tests for interaction, given proportions and sample sizes for all  *2 x k* combinations of predictors, using the above method.

Toy examples on how to use both functions are provided with the scripts. For feedback, suggestions and errors, please contact *stefan-gehrig[at]t-online.de*.