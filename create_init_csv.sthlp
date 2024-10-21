{smcl}
{* *! version 0.1.4 21oct2024}
{help create_init_csv:create_init_csv}
{hline}

{title:undidjl}

{pstd}
undidjl - Stata wrapper for the Undid.jl Julia package. Estimate difference-in-differences with unpoolable data. {p_end}

{title:Command Description}

{phang}
{cmd:create_init_csv} Creates an initial .csv file (init.csv), displays its filepath, and returns its contents to the active Stata dataset.

Required parameters:
- none

Optional parameters:
- {bf:silo_names} : A string specifying the different silo names.

- {bf:start_times} : A string which indicates the starting time for the analysis at each silo.

- {bf:end_times} : A string which indicates the end time for the analysis at each silo.

- {bf:treatment_times} : A string which indicates the treatment time at each silo. Control silos should be labelled with the treatment time "control".

- {bf:covariates} : A string specifying covariates to be considered at each silo.

{title:Syntax}

{pstd}
{cmd:create_init_csv} [{it:silo_names(string)} {it:start_times(string)} {it:end_times(string)} {it:treatment_times(string)} {it:covariates(string)}]{p_end}

{title:Examples}

{phang2}{cmd:create_init_csv, silo_names("71 73 58 46") start_times("1989 1989 1989 1989") end_times ("2000 2000 2000 2000") treatment_times("1991 control 1993 control") covariates("asian black male")}

{phang2}init.csv saved to C:/Users/User/Documents/Project Files/init.csv

{phang2}{cmd:create_init_csv}

{phang2}init.csv saved to C:/Users/User/Documents/Project Files/init.csv

{title:Author}

{pstd}
Eric Jamieson{p_end}

{pstd}
For more information about undidjl, visit the {browse "https://github.com/ebjamieson97/undidjl"} GitHub repository.{p_end}

{title:Citation}

{pstd}
Please cite: Sunny Karim, Matthew D. Webb, Nichole Austin, Erin Strumpf. 2024. Difference-in-Differenecs with Unpoolable Data. {browse "https://arxiv.org/abs/2403.15910"} {p_end}
