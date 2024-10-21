{smcl}
{* *! version 0.1.5 21oct2024}
{help undidjl_stage_two:undidjl_stage_two}
{hline}

{title:undidjl}

{pstd}
undidjl - Stata wrapper for the Undid.jl Julia package. Estimate difference-in-differences with unpoolable data. {p_end}

{title:Command Description}

{phang}
{cmd:undidjl_stage_two} creates an two .csv files (filled_diff_df_$silo_name.csv and trends_data_$silo_name.csv), 
displays their filepaths, and returns one .csv's contents to the active Stata dataset.

Required parameters: 
- {bf:filepath} : A string specifying the filepath to the empty_diff_df.csv.

- {bf:local_silo_name} : A string which specifies the local silo's name as it is written in the empty_diff_df.csv.

- {bf:time_column} : A string which indicates the name of the variable in the local silo data which contains the date information. 
This variable should be a string.

- {bf:outcome_column} : A string specifying the name of the variable in the local silo data which contains the outcome of interest.

- {bf:local_date_format} : A string specifying the date format used in the time_column variable. Valid formats include:
("yyyy/mm/dd", "yyyy-mm-dd", "yyyymmdd", "yyyy/dd/mm", "yyyy-dd-mm", "yyyyddmm", "dd/mm/yyyy", "dd-mm-yyyy", "ddmmyyyy", "mm/dd/yyyy", 
"mm-dd-yyyy", "mmddyyyy", "mm/yyyy", "mm-yyyy", "mmyyyy", "yyyy", "ddmonyyyy", "yyyym00")

Optional parameters:
- {bf:consider_covariates} : A string which if set to "false" ignores computations involving the covariates specified in the empty_diff_df.csv. 
Defaults to "true".

- {bf:view_dataframe} : Specify which dataframe should be passed back to Stata's active dataset. Either "trends" or "diff". Defaults to "diff".


{title:Syntax}

{pstd}
{cmd:undidjl_stage_two} filepath(string) local_silo_name(string) time_column(string) outcome_column(string) local_date_format(string) [{it:columns_to_rename(string)} {it:rename_to(string)} {it:consider_covariates(string)}]{p_end}

{title:Examples}

{phang2}{cmd:use "C:\Users\User\Documents\Project Files\State71.dta", clear}

{phang2}{cmd:undidjl_stage_two, filepath("C:/Users/User/Documents/Project Files/empty_diff_df.csv") local_silo_name("71") time_column("date_str") outcome_column("coll") local_date_format("ddmonyyyy")}

{phang2}filled_diff_df_71.csv saved to C:/Users/User/Documents/Project Files/filled_diff_df_71.csv 

{phang2}trends_data_71.csv saved to C:/Users/User/Documents/Project Files/trends_data_71.csv



{title:Author}

{pstd}
Eric Jamieson{p_end}

{pstd}
For more information about undidjl, visit the {browse "https://github.com/ebjamieson97/undidjl"} GitHub repository.{p_end}

{title:Citation}

{pstd}
Please cite: Sunny Karim, Matthew D. Webb, Nichole Austin, Erin Strumpf. 2024. Difference-in-Differenecs with Unpoolable Data. {browse "https://arxiv.org/abs/2403.15910"} {p_end}
