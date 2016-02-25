isH0 = function(input) {
  n_sims = 0
  
  pvalue = input$pvalue
  
  repeat {
    n_sims = n_sims + 1
    
    # Determine whether this attempt is from the null or alternative
    isH0 = rbinom(1, 1, input$pH0)
    
    if (isH0) { 
      # From the null hypothesis, i.e. y ~ N(0,1)
      y = rnorm(1)
    } else {    
      # From the alternative hypothesis, i.e. y ~ N(theta,1) and 
      # theta is drawn from a user defined distribution
      
      theta = switch(input$distribution,
                     'normal' = rnorm(1, input$normal_mean, input$normal_sd),
                     'point mass' = input$point_location,
                     't' = input$t_location+input$t_scale * rt(1,input$t_df),
                     'log-normal' = rlnorm(1, input$lognormal_location, input$lognormal_scale),
                     'gamma' = rgamma(1, input$gamma_shape, input$gamma_rate),
                     'beta' = rbeta(1, input$beta_shape1, input$beta_shape2),
                     'uniform' = runif(1, input$uniform_lb, input$uniform_ub))

      cat(theta)
      y = rnorm(1,theta)
    }
    
    # Calculcate the pvalue
    p = 2*(1-pnorm(abs(y)))
    
    # Determine whether it is close enough to our desired pvalue ()
    if (pvalue/1.1 < p & p < pvalue*1.1) break
    
    # Check to see if too many simulation attempts have been made without a pvalue 
    # falling in the appropriate range
    if (n_sims > input$max_sims) 
      stop("Maximum attempts reached. Increase maximum attempts or change settings.")
  }
  
  # If isH0=1, then the simulation with appropriate pvalue came from the null.
  # If isH0=0, then the simulation with appropriate pvalue came from the alternative.
  return(isH0)
}
