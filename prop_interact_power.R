
prop_interact_power <- function(props1, # outcome proportions for 1st level of main predictor (one element for each of k levels of interaction predictor)
                                props2, # outcome proportions for 2nd level of main predictor (one element for each of k levels of interaction predictor)
                                ns1,    # sample sizes for 1st level of main predictor (one element for each of k levels of interaction predictor)
                                ns2,    # sample sizes for 2nd level of main predictor (one element for each of k levels of interaction predictor)
                                sig.level = 0.05, # desired level of significance
                                variance = NULL){ # either "Wilson" or "Wald"
  
  if(!(length(props1) == length(props2) & length(ns1) == length(ns2) & 
     length(props1) == length(ns1)))                                    stop ("Input vectors do not all have equal length")
  if(!is.numeric(props1) | !is.numeric(props2) | !is.numeric(ns1) |
     !is.numeric(ns2))                                                  stop ("Proportion or sample size vectors are not numeric")
  if(length(props1) < 2)                                                stop ("Data for at least two subgroups (levels) must be provided")
  if(is.null(variance) | !variance %in% c("Wilson", "Wald"))            stop ("Choose a variance estimator, either 'Wald' or 'Wilson'")

  if(variance == "Wald"){
    temp_df <- data.frame(
      pdiff  = props1-props2,
      n1     = ns1,
      n2     = ns2,
      varsum = props1*(1-props1)/ns1 + props2*(1-props2)/ns2)}
  
  else{
    z <- qnorm(0.025, 0, 1, lower.tail = FALSE)
    
    temp_df <- data.frame(
      pdiff  = props1-props2,
      n1     = ns1,
      n2     = ns2,
      varsum = (z^2 + 4*ns1*props1*(1-props1)) / (4*(ns1 + z^2)^2) + (z^2 + 4*ns2*props2*(1-props2)) / (4*(ns2 + z^2)^2))}
  
  d0 <- sum( temp_df$varsum^-1 * temp_df$pdiff ) / sum( temp_df$varsum^-1 )
  U  <- sum( temp_df$varsum^-1 * (temp_df$pdiff - d0)^2 )
  
  pwr <- pchisq(qchisq(1-sig.level, df = nrow(temp_df)-1), df = 1, ncp = U, lower = FALSE)
  
  return(list(specification = temp_df,
              sig.level = sig.level,
              power = pwr))
}

## Example

# prop_interact_power(props1 = c(0.94,0.94),
#                     props2 = c(0.91,0.97),
#                     ns1 = c(500, 500),
#                     ns2 = c(500, 500),
#                     sig.level = 0.05,
#                     variance = "Wilson")