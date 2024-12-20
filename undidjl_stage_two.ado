  /*------------------------------------*/
/*undidjl_stage_two*/
/*written by Eric Jamieson */
/*version 0.1.10 2024-12-09 */
/*------------------------------------*/
version 14.1

cap program drop undidjl_stage_two
program define undidjl_stage_two

	syntax , filepath(string) local_silo_name(string) time_column(string) outcome_column(string) local_date_format(string) [consider_covariates(string) view_dataframe(string)]
	
	// Check for missing values in the time column
    quietly count if missing(`time_column')
    if r(N) > 0 {
        display as error "Error: Missing values found in time variable: `time_column'."
        exit 198
    }

    // Check for missing values in the outcome column
    quietly count if missing(`outcome_column')
    if r(N) > 0 {
        display as error "Error: Missing values found in outcome variable: `outcome_column'."
        exit 198
    }
	
	// Declare usage of Undid and start up Julia
	jl: using Undid
	
	// Allow variables to be passed to Julia
	global filepath = subinstr("`filepath'", "\", "/", .)
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
	qui jl: st_global("filepath_trends", outputs[2][1])	
	
	disp as result "filled_diff_df_$local_silo_name.csv saved to"
   	local filepath_diff_cleaned =  subinstr("$filepath_diff", "\", "/", .)
	disp as result "`filepath_diff_cleaned'"
	
	disp as result "trends_data_$local_silo_name.csv saved to"
	local filepath_trends_cleaned = subinstr("$filepath_trends", "\", "/", .)
   	disp as result "`filepath_trends_cleaned'"
	
	
	// Parse dataframe(string)
    if "`view_dataframe'" == "" | "`view_dataframe'" == "diff" {
        qui jl: diff_df = string.(outputs[1][2])
		qui jl: if "(g;t)" in DataFrames.names(diff_df) ///
				rename!(diff_df, Symbol("(g;t)") => :gt); ///
		end
		qui jl: if !any(x -> x == "missing", diff_df.diff_estimate) ///
					diff_df.diff_estimate = parse.(Float64, diff_df.diff_estimate); ///
				end

		qui jl: if !any(x -> x == "missing", diff_df.diff_var) ///
					diff_df.diff_var = parse.(Float64, diff_df.diff_var); ///
				end

		qui jl: if !any(x -> x == "missing", diff_df.diff_estimate_covariates) ///
					diff_df.diff_estimate_covariates = parse.(Float64, diff_df.diff_estimate_covariates); ///
				end

		qui jl: if !any(x -> x == "missing", diff_df.diff_var_covariates) ///
					diff_df.diff_var_covariates = parse.(Float64, diff_df.diff_var_covariates); ///
				end
 
		import delimited "`filepath_diff_cleaned'", varnames(1) clear
    }
	else if "`view_dataframe'" == "trends" {
		qui jl: trends_df = string.(outputs[2][2])
		qui jl: if !any(x -> x == "missing", trends_df.mean_outcome) /// 
					trends_df.mean_outcome =  parse.(Float64, trends_df.mean_outcome); ///
				end 
		qui jl: if !any(x -> x == "n/a" || x == "missing", trends_df.mean_outcome_residualized) ///
					trends_df.mean_outcome_residualized = parse.(Float64, trends_df.mean_outcome_residualized); ///
				end

		import delimited "`filepath_trends_cleaned'", varnames(1) clear
	}
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
*0.1.3 - fixed several typos, forget to close some brackets
*0.1.4 - convert numerical columns to Float64, so long as there are no missing values in column
*0.1.5 - converts any backslashes to forward slashes for better compatability between Julia and Stata
*0.1.6 - add warning for missing values in time or outcome variables
*0.1.7 - drop superfluous variables
*0.1.8 - renames (g;t) only if it exists (only for staggered adoption)
*0.1.9 - removed the line: <keep `time_column' `outcome_column'>
*0.1.10 - added robustness
