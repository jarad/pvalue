The idea behind this applet is to help gain an understanding of the interpretation of pvalues, by having the user specify an observed pvalue and calculating, via simulation, the probability that the null hypothesis is true. Toward this aim, the applet considers sampling a single observation from a normal distribution with unknown mean and unit variance and calculating a pvalue for the test of the mean being zero. 
      
For each simulation,  the following is performed:

1. Randomly determine whether next data will be sampled according to the null or alternative hypothesis based on the 'proportion of true null hypotheses'. 
1. If the null hypothesis is randomly selected, a random standard normal is drawn as the data. 
1. If the alternative hypothesis is randomly selected, first a mean is drawn from the 'alternative distribution' and then a random normal with this mean and unit variance is drawn. 
1. Then, a pvalue is calculated for the  null hypothesis that the true mean is zero. 
1. If this pvalue is close (within 10%) to the 'observed  pvalue' selected by the user, the applet records whether this result came from the null or alternative hypothesis. 
1. If the pvalue is not close, the applet retries the entire simulation from step 1.
      
For each simulation, the plot has a point indicating whether the simulation that produced the observed pvalue came from the null hypothesis (1) or the alternative hypothesis (0). In addition, the plot provides a running estimate (dashed line), as well as a 95% CI (solid line), for the probability that the null hypothesis is true.

The idea behind this app is [stolen from Jim Berger](http://www.stat.duke.edu/~berger/p-values.html) and German Molina who previously wrote a [similar applet in Java](http://www.stat.duke.edu/~berger/applet2/pvalue.html). 
