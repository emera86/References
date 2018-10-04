options pageno=min nodate formdlim='-';
title 'Compute 95% Confidence Interval for d, One-Sample or Correlated Samples';
Data CI;
**************************************************************************************************************
Replace tttt with the computed value of the one sample or correlated t test.
Replace nnn with the sample size -- number of scores in one sample or number of pairs of scores in correlated samples.
**************************************************************************************************************;
t = tttt  ;
n = nnn  ;
**************************************************************************************************************;
df = n-1;
d = t/sqrt(n);
ncp_lower = TNONCT(t,df,.975);
ncp_upper = TNONCT(t,df,.025);
d_lower = ncp_lower/sqrt(n);
d_upper = ncp_upper/sqrt(n);
output; run; proc print; var d d_lower d_upper; run;
**************************************************************************************************************
d is the point estimate of Cohen's d.
d_lower and d_upper are the lower and upper limits for a 95% confidence interal for Cohen's d.
For a different degree of confidence, just change the values in ncp_lower and ncp_upper -- for example, change them
from .975 and .025 to .95 and .05 if you want 90% confidence.
Caution:  When using this program with correlated samples, keep in mind that that the denominator of d is the
standard deviation of the difference scores, not the original scores in the two groups.
***************************************************************************************************************;

