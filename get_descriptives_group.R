## Libraries
require(reshape2)
require(Hmisc)
require(nlme)
require(gridExtra)

get_descriptives_group <- function(input, variables, group) {
  
  data <- input
  # Set Grouping Variable
  group_column <- which(names(data) == group)
  groups <- levels(factor(data[, group_column]))
  
  # Initialize Variables
  Variable <- ""
  Mean <- data.frame(matrix(0, nrow = 1, ncol = length(groups)))
  names(Mean) <- paste(groups, "_3.Mean", sep = "")
  sd <- data.frame(matrix(0, nrow = 1, ncol = length(groups)))
  names(sd) <- paste(groups, "_4.Standard_Deviation", sep = "")
  Minimum <- data.frame(matrix(0, nrow = 1, ncol = length(groups)))
  names(Minimum) <- paste(groups, "_5.Min", sep = "")
  Maximum <- data.frame(matrix(0, nrow = 1, ncol = length(groups)))
  names(Maximum) <- paste(groups, "_6.Max", sep = "")
  N <- data.frame(matrix(0, nrow = 1, ncol = length(groups)))
  names(N) <- paste(groups, "_2.N", sep = "")
  DF1 <- 0
  DF2 <- 0
  F_Stat <- 0
  P_Value <- 0
  
  
  for (i in 1:length(groups)) {
    data_temp <- data[data[, group_column] == groups[i], ]
    
    # Loop through variables
    for (j in 1:length(variables)) {
      column <- which(names(data_temp) == variables[j])
      Variable[j] <- names(data_temp)[column]
      Mean[j, i] <- mean(as.numeric(data_temp[, column]), na.rm = TRUE)
      sd[j, i] <- sd(as.numeric(data_temp[, column]), na.rm = TRUE)
      Minimum[j, i] <- min(as.numeric(data_temp[, column]), na.rm = TRUE)
      Maximum[j, i] <- max(as.numeric(data_temp[, column]), na.rm = TRUE)
      N[j, i] <- nrow(data_temp[!is.na(data_temp[, column]), ])
      output <- anova(aov(data[, column] ~ data[, group_column], na.action = na.omit))
      F_Stat[j] <- output[1, 4]
      P_Value[j] <- output[1, 5]
      DF1[j] <- output[1, 1]
      DF2[j] <- output[2, 1]
    }
  }
  
  Final <- data.frame(Variable)
  names(Final) <- "1.Variable"
  Final <- cbind(Final, Mean, sd, Minimum, Maximum, N)
  
  Final <- Final[sort(names(Final), decreasing = FALSE)]
  Final <- cbind(Final, F_Stat, P_Value, DF1, DF2)
  
  return(Final)
}
