{smcl}
{* *! version 0.1.0 04sep2024}
{help checkundidversion:checkundidversion}
{hline}

{title:undidjl}

{pstd}
undidjl - Stata wrapper for the Undid.jl Julia package.{p_end}

{title:Command Description}

{phang}
{cmd:plot_parallel_trends} plots parallel trends figures.

The required arguments are: folder(string) which takes in a filepath to folder where all of the trends_data_$silo_name.csv files are stored; outcome_variable(string)
which takes in a name of the outcome variable which will be used in the plot title; and date_format(string) which can be set to "yearly", "monthly", "day_and_month", or "full_date",
and is used to determine how the dates are displayed along the x-axis of the plot. 

The optional arguments are: 
- silos(string) which allows for inputting silo names for which you would like to restrict the plotting to. Silos should be all be entered as one string with spaces between them.
- omit_silos(string) which allows for inputting silo names that you would like to be disregarded for the plotting. Silos should be all be entered as one string with spaces between them.
- covariates(string) which can be set to true or false. When set to true the mean outcome variable residualized by covariates is plotted, and when set to false
the mean outcome variable is plotted. False by default.
- combine(string) can be set to true or false. When set to true it plots the average of the mean outcome variable (residualized by covariates if covariates(string) is set to true)
across treatment & control groups, respectively. False by default.
- step(numlist int max=1) which takes in an integer value but is 1 by default. This determines how many dates are shown along the x-axis. 1 means that every date will be shown,
2 would display every 2nd date, 3 would display every 3rd date, and so on.
-save_csv(string) can be set to true or false. Saves the combined_trends_data as a .csv file is set to true. True by default. 

{title:Syntax}

{pstd}
{cmd:plot_parallel_trends} folder(string) outcome_variable(string) [silos(string) save_csv(string) covariates(string)	omit_silos(string) date_format(string) combine(string) step(numlist int max=1)]

{title:Examples}

{phang2}{cmd:plot_parallel_trends, folder("C:/Users/User/Documents/Project Files/Trends Data") outcome_variable("College Attendance") date_format("yearly") combine("true") step(2)}

{title:Author}

{pstd}
Eric Jamieson{p_end}

{pstd}
For more information about Undid.jl, visit the {browse "https://github.com/ebjamieson97/undidjl"} GitHub repository.{p_end}

{title:Citation}

{pstd}
Please cite: Sunny Karim, Matthew D. Webb, Nichole Austin, Erin Strumpf. 2024. Difference-in-Differenecs with Unpoolable Data. {p_end}
