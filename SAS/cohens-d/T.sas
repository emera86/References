options pageno=min nodate formdlim='-';
title ' One Sample T-Test With Howell Data, IQ of Students in Vermont'; run;
data sasdata.howell; infile "I:\PROJECTS\ABBOTT\Medicina Interna\ABT0612_ADEQUA\Biostatistics\2-Peticiones-extra_apr18\sasdata\HOWELL_test_dCohen.dat";
input addsc sex repeat iq engl engg gpa socprob dropout;
IQ_diff = iq - 100;	run;
*Want to test null hypothesis that mean IQ is 100;
ods trace on;
proc means mean stddev n skewness kurtosis t prt CLM; var iq IQ_diff; run;
ods trace off;
*See http://core.ecu.edu/psyc/wuenschk/SAS/Conf-Interval-d1.sas ;
Data CI1;
**************************************************************************************************************
t is the computed value of the one sample or correlated t test.
n is the sample size -- number of scores in one sample or number of pairs of scores in correlated samples.
**************************************************************************************************************;
t = 0.19  ;
n = 88  ;
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
title 'Experiment 2 of Karl''s Dissertation';
title2 'Correlated t-tests, Visits to Mus Tunnel vs Rat Tunnel, Three Nursing Groups '; run;
data Mus;  infile 'C:\Users\Vati\Documents\_XYZZY\_Stats\StatData\tunnel2.dat';
input nurs $ 1-2 L1 3-5 L2 6-8 t1 9-11 t2 12-14 v_mus 15-16 v_rat 17-18;
*t_mus=sqrt(1.575 * t1 + .5); *t_rat=sqrt(1.575 * t2 + .5);
*L_mus=LOG10(1.575 * L1 + 1); *L_rat=LOG10(1.575 * L2 + 1);
 v_diff=v_mus - v_rat; *t_diff=t_mus - t_rat; *L_diff=L_mus - L_rat;
proc sort; by nurs;
proc means mean stddev n skewness kurtosis t prt CLM;
var V_mus V_rat V_diff; by nurs;
run;
*-------------------------------------------------------------------------;
proc corr nosimple; var V_Mus; with V_rat; by nurs; run;
Data CI2;
m1=22.4375 ;
m2= 7.5625  ;
s1=12.8164933  ;
s2= 5.8874867  ;
r= 0.58052 ; 
n=16    ;
prob=.95 ;
v1=s1**2;
v2=s2**2;
s12=s1*s2*r; 
se=sqrt((v1+v2-2*s12)/n);
pvar=(v1+v2)/2;
nchat=(m1-m2)/se;
es=(m1-m2)/(sqrt(pvar));
df=n-1;
ncu=TNONCT(nchat,df,(1-prob)/2);
ncl=TNONCT(nchat,df,1-(1-prob)/2);
ul=se*ncu/(sqrt(pvar));
ll=se*ncl/(sqrt(pvar));
output;
proc print;
title1 'll is the lower limit and ul is the upper limit';
title2 'of a confidence interval for the effect size';
title3 'MM group only' ;
var es ll ul ;
run;
**********************************************************************;
title1 'Independent Samples T-Tests on Mouse-Rat Tunnel Difference Scores';
title2 'Foster Mom is a Mouse or is a Rat'; run;
data Mus2; set Mus;
if nurs NE 'RR' then Mom = 'Mouse';
else if nurs = 'RR' then Mom = 'Rat';
proc ttest; class Mom; var v_diff; run;
title2 'Foster Mom is a Mouse, Pups Exposed to Rat Scent (MR) or Not (MM)'; run;
data CI3;
t= 5.96  ;
df = 46  ;
n1 = 32  ;
n2 = 16  ;
***********************************************************************************;
d = t/sqrt(n1*n2/(n1+n2));
ncp_lower = TNONCT(t,df,.975);
ncp_upper = TNONCT(t,df,.025);
d_lower = ncp_lower*sqrt((n1+n2)/(n1*n2));
d_upper = ncp_upper*sqrt((n1+n2)/(n1*n2));
output; run; proc print; var d d_lower d_upper; run;
***********************************************************************************;
data Mus3; set Mus; if nurs NE 'RR';
proc ttest; class nurs; var v_diff; run;
*****************************************************************************;
title 'Independent t on WTLOSS Data'; run;
data wtloss;
input program $ loss @@ ; cards;
A 25 A 21 A 18 A 20 A 22 A 30
B 15 B 17 B 9 B 12 B 11 B 19 B 14 B 18 B 16 B 10 B 5 B 13
proc ttest; class program; var loss; run;
data CI4;
t= 4.54  ;
df = 16  ;
n1 = 6  ;
n2 = 12  ;
***********************************************************************************;
d = t/sqrt(n1*n2/(n1+n2));
ncp_lower = TNONCT(t,df,.975);
ncp_upper = TNONCT(t,df,.025);
d_lower = ncp_lower*sqrt((n1+n2)/(n1*n2));
d_upper = ncp_upper*sqrt((n1+n2)/(n1*n2));
output; run; proc print; var d d_lower d_upper; run;
