prop_interact <- function(
  data = NULL,         # data frame
  main = NULL,         # column name of variable for main predictor, cannot be empty, 
                       # must be factor or character with exact two levels
  interact = NULL,     # column name of variable for interaction predictor, cannot be empty, 
                       # must be factor or character with minimum k = 2 levels
  outcome = NULL,      # outcome variable, can be factor, character or numeric, cannot be empty, must be binary
  variance = "Wilson"  # either "Wilson" or "Wald"
){
  
  ### Data checks
  
  #Input checks
  if (is.null(data))                                             stop ("Provide dataframe")
  if (is.null(main) | !is.character(main))                       stop ("Provide quoted column name for main predictor variable")
  if (is.null(interact) | !is.character(interact))               stop ("Provide quoted column name for interaction predictor variable")
  if (is.null(variance) | !variance %in% c("Wilson", "Wald"))    stop ("Choose a variance estimator, either 'Wald' or 'Wilson'")
  if (is.null(outcome))                                          stop ("Provide a quoted column name for outcome variable")

  #Input transformations
  data <- as.data.frame(data)
  mvar <- as.factor(data[,main])
  kvar <- as.factor(data[,interact])
  outc <- as.factor(data[,outcome])
  
  #Level checks
  if (length(levels(mvar)) != 2)  stop("Predictor for main effect does not have exactly two levels") 
  if (length(levels(kvar)) < 2)   stop("Predictor for interaction effect does not have two or more levels")
  if (length(levels(outc)) != 2)  stop("Outcome does not have exactly two levels (is not binary)")
  
  ### Calculate test statistic
  
  #Create contingency table and extract values for each k
  ct <- addmargins(table(mvar, kvar))
  l <- length(levels(kvar))

  #Create contingency tables into a list for calculation
  temp <- list(NA)
  for (i in seq(1, l ,1)){
    temp[[i]] <- table(mvar[kvar == levels(kvar)[i]], outc[kvar == levels(kvar)[i]])
  }
  
  #Extract values and calculate proportions and subgroup sample sizes from list
  temp <- lapply(temp, FUN = function(x){c(prop.in = x[,1]/(x[,1]+x[,2]), 
                                           n.in    = (x[,1]+x[,2]))})
  
  #Calculate variance and proportion difference for each k in the list
  if(variance == "Wald"){
    temp <- lapply(temp, FUN = function(x){c(x, 
                                             varsum = unname((x[1] * (1-x[1]))/x[3] + (x[2] * (1-x[2]))/x[4]),
                                             prop.diff  = unname((x[1] - x[2])))})}
  
  else{
    z <- qnorm(0.025, lower.tail = FALSE)
    
    temp <- lapply(temp, FUN = function(x){c(x, 
                                             varsum = unname(
                                               (z^2 + 4*x[3]*x[1]*(1-x[1])) / (4*(x[3] + z^2)^2) + (z^2 + 4*x[4]*x[2]*(1-x[2])) / 
                                                 (4*(x[4] + z^2)^2)
                                               ),
                                             prop.diff  = unname((x[1] - x[2])))})}
  
  #Transform into table
  temp_df        <- data.frame(k = levels(kvar), matrix(unlist(temp), nrow=length(temp), byrow=T))
  names(temp_df) <- c(interact, names(temp[[1]]))
  
  #Calculate test statistic
  d0 <- sum( temp_df$varsum^-1 * temp_df$prop.diff ) / sum( temp_df$varsum^-1 )
  U  <- sum( temp_df$varsum^-1 * (temp_df$prop.diff - d0)^2 )
  
  #Obtain p-value
  p  <- pchisq(U, df = length(levels(kvar)) - 1, lower.tail = FALSE)
  
  
  ### Return results
  
  return(list(
    "results for each level" = temp_df, 
    "statistic" = paste0(round(U,3), " (df = ", length(levels(kvar)) - 1, ")"),
    "p interaction" = p))
}

### Example
### Interaction effect of treatment (2 levels) and diabetes subgroups (3 levels) on binary outcome
# df <- data.frame(
#   treatarm = sample(c("control","treat"), replace = TRUE, size = 500),
#   diabetes = sample(c("I", "II", "none"), replace = TRUE, size = 500),
#   endpoint = sample(c(1, 0), replace = TRUE, size = 500))
# 
# prop_interact(
#   data     = df,
#   main     = "treatarm",
#   interact = "diabetes",
#   outcome  = "endpoint",
#   variance = "Wilson"
# )