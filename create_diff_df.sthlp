{smcl}
{* *! version 0.2.1 23oct2024}
{help create_diff_df:create_diff_df}
{hline}

{title:undidjl}

{pstd}
undidjl - Stata wrapper for the Undid.jl Julia package. Estimate difference-in-differences with unpoolable data. {p_end}

{title:Command Description}

{phang}
{cmd:create_diff_df} creates the empty_diff_df.csv file which is to be sent to the various silos to be filled out. 

Required parameters:
- {bf:filepath} : A string specifying the filepath to the init.csv

- {bf:date_format} : A string which specifies the date format used in the init.csv ("yyyy/mm/dd", "yyyy-mm-dd", "yyyymmdd", "yyyy/dd/mm",
"yyyy-dd-mm", "yyyyddmm", "dd/mm/yyyy", "dd-mm-yyyy", "ddmmyyyy", "mm/dd/yyyy", "mm-dd-yyyy", "mmddyyyy", "mm/yyyy", "mm-yyyy", "mmyyyy",
"yyyy", "ddmonyyyy", "yyyym00")

- {bf:freq} : A string which indicates the length of the time periods to be used when computing the differences in mean outcomes between
periods at each silo. Either "daily", "weekly", "monthly", or "yearly".


Optional parameters:
- {bf:covariates} : A string specifying covariates to be considered at each silo. If left blank uses covariates from init.csv.

- {bf:freq_multiplier} : An integer or string which specifies if the frequency should be multiplied by a non-zero integer. 
For example, if the time periods to consider are two years, set freq("yearly") freq_multiplier(2)

- {bf:weights} : A string indicating the type of weighting to use in the case of common adoption. Defaults to "standard". Options are:
    -> "standard" weighs each silo according to (num of obs after and at the treatment period) / (num of obs)


{title:Syntax}

{pstd}
{cmd:create_diff_df} filepath(string) date_format(string) freq(string) [{it:covariates(string)} {it:freq_multiplier(string)} {it:confine_matching(string)}]{p_end}

{title:Examples}

{phang2}{cmd:create_diff_df, filepath("C:/Users/User/Documents/Project Files/init.csv") date_format("yyyy") freq("yearly") covariates("asian male black")}

{phang2}empty_diff_df.csv saved to C:/Users/User/Documents/Project Files/empty_diff_df.csv

{title:Author}

{pstd}
Eric Jamieson{p_end}

{pstd}
For more information about undidjl, visit the {browse "https://github.com/ebjamieson97/undidjl"} GitHub repository.{p_end}

{title:Citation}

{pstd}
Please cite: Sunny Karim, Matthew D. Webb, Nichole Austin, Erin Strumpf. 2024. Difference-in-Differenecs with Unpoolable Data. {browse "https://arxiv.org/abs/2403.15910"} {p_end}
