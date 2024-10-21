{smcl}
{* *! version 0.1.0 21oct2024}
{help checkundidversion:checkundidversion}
{hline}

{title:undidjl}

{pstd}
undidjl - Stata wrapper for the Undid.jl Julia package. Estimate difference-in-differences with unpoolable data. {p_end}

{title:Command Description}

{phang}
{cmd:plot_parallel_trends} plots parallel trends figures.

Required parameters:
- {bf:folder} :  A string specifying the filepath to the folder containing all of the trends_data_$silo_name.csv's.

- {bf:outcome_variable" : A string which is used as the title of plot. 

Optional parameters:
- {bf:silos} : A string which confines the plotting to the specified silos.

- {bf:save_csv} : A string (either "true" or "false") which determines whether or not to save the combined_trends_data.csv. Defaults to "true".

- {bf:covariates} : A string (either "true" or "false") which determines whether to plot the mean outcome or 
the mean outcome residualized by covariates. Defaults to "false" (plots the mean outcome).

- {bf:omit_silos} : A string which omits the specified silos from the plot.

- {bf:date_format} : A string determining the format of the dates to appear on the x-axis of the plot. Options include:
    -> "yearly" or "%tdCCYY"
    -> "monthly" or "%tdMonYY"
    -> "full_date" or "%tdDD-NN-CCYY"
    -> "day_and_month" or "%tdDDMon"

- {bf:combine} : A string (either "true" or "false") which if set to "true" plots two lines: one line for the combined average across treated silos, 
and one line for the combined average across control silos. Otherwise plots every silo individually. Defaults to "false".

- {bf:step} : An integer for determining the number of periods between each date shown on the x-axis. Defaults to 1.


{title:Syntax}

{pstd}
{cmd:plot_parallel_trends} folder(string) outcome_variable(string) [silos(string) save_csv(string) covariates(string)	omit_silos(string) date_format(string) combine(string) step(numlist int max=1)]

{title:Examples}

{phang2}{cmd:plot_parallel_trends, folder("C:/Users/User/Documents/Project Files/Trends Data") outcome_variable("College Attendance") date_format("yearly") combine("true") step(2)}

{title:Author}

{pstd}
Eric Jamieson{p_end}

{pstd}
For more information about undidjl, visit the {browse "https://github.com/ebjamieson97/undidjl"} GitHub repository.{p_end}

{title:Citation}

{pstd}
Please cite: Sunny Karim, Matthew D. Webb, Nichole Austin, Erin Strumpf. 2024. Difference-in-Differenecs with Unpoolable Data. {browse "https://arxiv.org/abs/2403.15910"} {p_end}
