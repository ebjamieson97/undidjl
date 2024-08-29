{smcl}
{* *! version 0.1.1 29aug2024}
{help undidjl_stage_two:undidjl_stage_two}
{hline}

{title:undidjl}

{pstd}
undidjl - Stata wrapper for the Undid.jl Julia package.{p_end}

{title:Command Description}

{phang}
{cmd:undidjl_stage_two} reads in information from the empty_diff_df.csv file and from the active dataset in Stata. Produces filled_diff_$local_silo_name.csv and trends_data_$local_silo_name.csv. 

The required arguments are: the filepath(string) to the empty_diff_df.csv file; the corresponding name of the local silo as it is written in the empty_diff_df.csv, local_silo_name(string); the name of the column
where the date/time data is stored in the active dataset in Stata, time_column(string); the name of the column where the data of the outcome of interest is stored in the active dataset in Stata, outcome_column(string); 
and finally, the local_date_format(string) of the date/time data in the active dataset in Stata. The valid options for the local_date_format(string) are ["yyyy/mm/dd", "yyyy-mm-dd", "yyyymmdd", "yyyy/dd/mm", "yyyy-dd-mm",
"yyyyddmm", "dd/mm/yyyy", "dd-mm-yyyy", "ddmmyyyy", "mm/dd/yyyy", "mm-dd-yyyy", "mmddyyyy", "mm/yyyy", "mm-yyyy", "mmyyyy", "yyyy", "ddmonyyyy", "yyyym00"].

Optional arguments (have not been added yet) are columns_to_rename(string) and rename_to(string). Columns should be listed as a single string with seperate column names seperated by a space. Likewise rename_to(string) takes 
in a single string with the corresponding new names for the columns. Any covariates in the local silo should be renamed to match the covariates as they are named in the empty_diff_df.csv. Otherwise, it is also possible to 
specify consider_covariates("false") as an optional argument which will then run stage two procedures while ignoring any calculations involving any covariates.

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
For more information about Undid.jl, visit the {browse "https://github.com/ebjamieson97/undidjl"} GitHub repository.{p_end}

{title:Citation}

{pstd}
Please cite: Sunny Karim, Matthew D. Webb, Nichole Austin, Erin Strumpf. 2024. Difference-in-Differenecs with Unpoolable Data.{p_end}
