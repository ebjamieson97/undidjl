{smcl}
{* *! version 0.1.0 29aug2024}
{help undidjl_stage_three:undidjl_stage_three}
{hline}

{title:undidjl}

{pstd}
undidjl - Stata wrapper for the Undid.jl Julia package.{p_end}

{title:Command Description}

{phang}
{cmd:undidjl_stage_three} reads in information from all of the filled_diff_df_$silo_names.csv files and computes the aggregate ATT.

The only required argument is: folder(string) which specifies the filepath to the folder in which all of the filed_diff_df$silo_names.csv files are stored. 

Optional arguments are:
agg(string) the aggregation method. By default it is set to aggregate ATTs across silos, but can be set to "gt" or "g" instead. Aggregating across g calculates ATTs for groups based on when the treatment time was, with 
each g group having equal weight. Aggregating across gt calculates ATTs for groups based on when the treatment time was and the time for which the ATT is calculated. There may be n number of gt groups that make up a g group.
This option is ignored in the case of a common treatment time and only takes effect in the case of staggered adoption. 

covariates(string) which is set to false by default, inputting true will calculate the aggregate with the covariates in mind, that is, using the diff_estimate_covariate columns from the 
filled_diff_df$silo_names.csv files. 

save_all_csvs(string) can be set to true or false and saves the combined filled_diff_df$silo_names.csv files as a single .csv file. False by default

interpolation(string) selects the type of interpolation/extrapolation used to fill in any missing diff_estimate's or diff_estimate_covariates in the combined filled_diff_df$silo_names dataset. Currently the only supported
method is a linear_function, which in the case of only one available datapoint for that particular (silo,g) group will simply copy that diff_estimate or diff_estimate_covariates to the missing values for that (silo,g) group.

{title:Syntax}

{pstd}
{cmd:undidjl_stage_three} folder(string) [{it:agg(string)} {it:covariates(string)} {it:save_all_csvs(string)} {it:interpolation(string)}]

{title:Examples}

{phang2}{cmd:undidjl_stage_three, folder("C:/Users/User/Documents/Filled Diff Files/") agg("g") covariates("true") save_all_csvs("true") interpolation("linear_function")}

{title:Author}

{pstd}
Eric Jamieson{p_end}

{pstd}
For more information about Undid.jl, visit the {browse "https://github.com/ebjamieson97/undidjl"} GitHub repository.{p_end}

{title:Citation}

{pstd}
Please cite: Sunny Karim, Matthew D. Webb, Nichole Austin, Erin Strumpf. 2024. Difference-in-Differenecs with Unpoolable Data.{p_end}
