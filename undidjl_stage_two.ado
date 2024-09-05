/*------------------------------------*/
/*undidjl_stage_two*/
/*written by Eric Jamieson */
/*version 0.1.2 2024-09-05 */
/*------------------------------------*/
version 14.1

cap program drop undidjl_stage_two
program define undidjl_stage_two

	syntax , filepath(string) local_silo_name(string) time_column(string) outcome_column(string) local_date_format(string) [consider_covariates(string) dataframe(string)]
	
	// Declare usage of Undid and start up Julia
	jl: using Undid
	
	// Allow variables to be passed to Julia
	global filepath = "`filepath'"
	global local_silo_name = "`local_silo_name'"
	global time_column = "`time_column'"
	global outcome_column = "`outcome_column'"
	global local_date_format = "`local_date_format'"
	
		// Parse consider_covariates
	if "`consider_covariates'" == "" | "`consider_covariates'" == "TRUE" | "`consider_covariates'" == "true" | "`consider_covariates'" == "T" | "`consider_covariates'" == "True" {
		qui jl: consider_covariates = true
	}
	else if  "`consider_covariates'" == "FALSE" | "`consider_covariates'" == "false" | "`consider_covariates'" == "F" | "`consider_covariates'" == "False" {
		qui jl: consider_covariates = false
	}
	else { 
		display as error "Error: set consider_covariates to true or false or omit the argument (defaults to true)."
		exit 198
	}
	
	qui jl save df
	
	qui jl: outputs = run_stage_two("$filepath", "$local_silo_name", df, "$time_column", "$outcome_column","$local_date_format", consider_covariates = consider_covariates)
	
	qui jl: st_global("filepath_diff", outputs[1][1])
	qui jl: st_global("filepath_trends", outputs[2][1)	
	disp as result "filled_diff_df_$local_silo_name.csv saved to"
   	disp as result subinstr("$filepath_diff", "\", "/", .)
	disp as result "trends_data_$local_silo_name.csv saved to"
   	disp as result subinstr("$filepath_trends", "\", "/", .)
	
	
	// Parse dataframe(string)
    if "`dataframe'" == "" | "`dataframe'" == "diff" {
        qui jl: diff_df = string.(outputs[1][2])
		qui jl: rename!(diff_df, Symbol("(g;t)") => :gt)
		jl use diff_df, clear
    }
	else if "`dataframe'" == "trends" {
		qui jl: trends_df = string.(outputs[2][2])
		jl use trends_df, clear
	else {
		di as error "Please indicate which dataframe you'd like to view as the active dataset: 'trends' or 'diff'. Defaults to 'diff' if argument is not specified."
		exit 198
	}
	
	
end 


/*--------------------------------------*/
/* Change Log */
/*--------------------------------------*/
*0.1.1 - added option to ignore covariates specified from stage one
*0.1.2 - now returns either the trends data or filled diff df to the active Stata dataset
