{smcl}
{* *! version 0.1.4 21oct2024}
{help undidjl_stage_three:undidjl_stage_three}
{hline}

{title:undidjl}

{pstd}
undidjl - Stata wrapper for the Undid.jl Julia package. Estimate difference-in-differences with unpoolable data. {p_end}

{title:Command Description}

{phang}
{cmd:undidjl_stage_three} computes and displays UNDID results (aggregate ATT, standard errors, p-values).

Required parameters:
- {bf:folder} :  A string specifying the filepath to the folder containing all of the filled_diff_df_$silo_name.csv's.

Optional parameters:
- {bf:agg} : A string which specifies the aggregation methodology for computing the aggregate ATT in the case of staggered adoption. 
Either "silo", "g", or "gt". Defaults to "silo".

- {bf:covariates} : A string (either "true" or "false") which specifies whether to use the diff_estimate or the diff_estimate_covariates
column when computing the aggregate ATT. Defaults to "false".

- {bf:save_csv} : A string (either "true" or "false") which determines whether or not to save the combined_diff_data.csv. Defaults to "true".

- {bf:interpolation:} : A string (either "false" or "linear_function") which specifies which, if any, method of interpolation/extrapolation for missing values
of diff_estimate or diff_estimate_covariates should be used. Defaults to "false". There must be at least one value for the (silo,g) group for which a missing value
is being estimated in order for "linear_function" interpolation to work.


{title:Syntax}

{pstd}
{cmd:undidjl_stage_three} folder(string) [{it:agg(string)} {it:covariates(string)} {it:save_all_csvs(string)} {it:interpolation(string)}]

{title:Examples}

{phang2}{cmd:undidjl_stage_three, folder("C:/Users/User/Documents/Files From Silos") agg("g") covariates("true")}

Saving combined_diff_data.csv to C:\Current Working Directory
Saving UNDID_results.csv to C:\Current Working Directory

------------------------------------------------------
                     UNDID Results                    
------------------------------------------------------
g                         | ATT                      |
--------------------------|--------------------------|
1991                      |-0.0124840                |
--------------------------|--------------------------|
1993                      |0.1865795                 |
--------------------------|--------------------------|
Aggregation: g
Aggregate ATT: .08704778
Jackknife SE: .09953177
Jackknife p-value: .54253268
RI p-value: .5

{title:Author}

{pstd}
Eric Jamieson{p_end}

{pstd}
For more information about undidjl, visit the {browse "https://github.com/ebjamieson97/undidjl"} GitHub repository.{p_end}

{title:Citation}

{pstd}
Please cite: Sunny Karim, Matthew D. Webb, Nichole Austin, Erin Strumpf. 2024. Difference-in-Differenecs with Unpoolable Data. {browse "https://arxiv.org/abs/2403.15910"} {p_end}
