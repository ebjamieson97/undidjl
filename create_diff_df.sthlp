{smcl}
{* *! version 0.1.0 27aug2024}
{help create_diff_df:create_diff_df}
{hline}

{title:undidjl}

{pstd}
undidjl - Stata wrapper for the Undid.jl Julia package.{p_end}

{title:Command Description}

{phang}
{cmd:create_diff_df} creates the empty_diff_df.csv file which is to be sent to the seperate silos to be filled out. 
The required arguments are: the filepath to the init.csv which should be inputed as a string with forward slashes; the date_format which should be inputed as a string 
such as ["yyyy/mm/dd", "yyyy-mm-dd", "yyyymmdd", "yyyy/dd/mm", "yyyy-dd-mm", "yyyyddmm", "dd/mm/yyyy", "dd-mm-yyyy", "ddmmyyyy", "mm/dd/yyyy", 
"mm-dd-yyyy", "mmddyyyy", "mm/yyyy", "mm-yyyy", "mmyyyy", "yyyy", "ddmonyyyy", "yyyym00"] and accurately reflect the format of the dates stored in init.csv; the freq of data
which should be inputed as either "daily", "weekly", "monthly", or "yearly".

If no covariates are specified in the init.csv you can specify them when calling create_diff_df by specifying them as a single string (e.g. covariates("asian black male")). 
freq_multiplier can optionally be set as some non-zero integer although it should be inputed as a string (e.g. freq_multiplier("5")). 
confine_matching can be set to "true" or "false" but is set to "true" by default. If it is set to false the data at the silos will be 'fuzzy matched' to the closest dates
specified in the empty_diff_df diff_times column. This has no bearing if there is a common treatment time and only takes effect if there is staggered adoption. 
The default date matching procedure matches dates at each silo to the most recently passed date in the diff_times column from the empty_diff_df. 

{title:Syntax}

{pstd}
{cmd:create_diff_df} filepath(string) date_format(string) freq(string) [{it:covariates(string)} {it:freq_multiplier(string)} {it:confine_matching(string)}]{p_end}

{title:Examples}

{phang2}{cmd:create_diff_df, filepath("C:/Users/User/Documents/Project Files/empty_diff_df.csv") date_format("yyyy") freq("yearly")}

{phang2}empty_diff_df.csv saved to C:/Users/User/Documents/Project Files/empty_diff_df.csv

{title:Author}

{pstd}
Eric Jamieson{p_end}

{pstd}
For more information about Undid.jl, visit the {browse "https://github.com/ebjamieson97/undidjl"} GitHub repository.{p_end}

{title:Citation}

{pstd}
Please cite: Sunny Karim, Matthew D. Webb, Nichole Austin, Erin Strumpf. 2024. Difference-in-Differenecs with Unpoolable Data.{p_end}
