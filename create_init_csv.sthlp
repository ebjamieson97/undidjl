{smcl}
{* *! version 0.1.0 27aug2024}
{help create_init_csv:create_init_csv}
{hline}

{title:undidjl}

{pstd}
undidjl - Stata wrapper for the Undid.jl Julia package.{p_end}

{title:Command Description}

{phang}
{cmd:create_init_csv} creates the init.csv file required to build the empty_diff table which itself is sent to the seperate silos to be filled out. 
{cmd:create_init_csv} can be called with or without optional arguments. Arguments must be passed as strings seperated by spaces and dates must be formatted identically.
Acceptable date formats are given by: ["yyyy/mm/dd", "yyyy-mm-dd", "yyyymmdd", "yyyy/dd/mm", "yyyy-dd-mm", "yyyyddmm", "dd/mm/yyyy", "dd-mm-yyyy", "ddmmyyyy", "mm/dd/yyyy", 
"mm-dd-yyyy", "mmddyyyy", "mm/yyyy", "mm-yyyy", "mmyyyy", "yyyy", "ddmonyyyy", "yyyym00"]. Control silos should indicate "control" under the argument treatment_times as shown in the example.
silo_names, start_times, end_times, and treatment_times should all have the same number of entries. Covariates may have zero to n entries. 

It is recommended to simply call create_init_csv and then fill out the information as needed directly from the init.csv if there are many silos to consider. 

{title:Syntax}

{pstd}
{cmd:create_init_csv} [{it:silo_names(string)} {it:start_times(string)} {it:end_times(string)} {it:treatment_times(string)} {it:covariates(string)}]{p_end}

{title:Examples}

{phang2}{cmd:create_init_csv, silo_names("71 73 58 46") start_times("1989 1989 1989 1989") end_times ("2000 2000 2000 2000") treatment_times("1991 control 1993 control") covariates("asian black male")}

{phang2}init.csv saved to C:\Users\User\Documents\Project Files\init.csv

{phang2}{cmd:create_init_csv}

{phang2}init.csv saved to C:\Users\User\Documents\Project Files\init.csv

{title:Author}

{pstd}
Eric Jamieson{p_end}

{pstd}
For more information about Undid.jl, visit the {browse "https://github.com/ebjamieson97/undidjl"} GitHub repository.{p_end}

{title:Citation}

{pstd}
Ipsum lorem dolor.{p_end}
