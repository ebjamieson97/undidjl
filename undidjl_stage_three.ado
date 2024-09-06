/*------------------------------------*/
/*undidjl_stage_three*/
/*written by Eric Jamieson */
/*version 0.1.2 2024-09-06 */
/*------------------------------------*/
version 14.1


cap program drop undidjl_stage_three
program define undidjl_stage_three

	syntax , folder(string) [agg(string) covariates(string) save_csv(string) interpolation(string)]
	
	// Declare usage of Undid and start up Julia
	jl: using Undid
	jl: using DataFrames
	
	// Allow variables to be passed to Julia
	global folder = "`folder'"

	// Parse agg 
	if "`agg'" == "" | "`agg'" == "silo"{
		qui jl: agg = "silo"
	}
	else if "`agg'" == "gt"{
		qui jl: agg = "gt"
	}
	else if "`agg'" == "g"{
		qui jl: agg = "g"
	}
	else {
		disp as error "Please set aggregration to silo, g, or gt."
	}
	
	// Parse covariates
	if "`covariates'" == "TRUE" | 	"`covariates'" == "true" | "`covariates'" == "T" | "`covariates'" == "True" {
		qui jl: covariates = true
	}
	else if "`covariates'" == "" | "`covariates'" == "FALSE" | "`covariates'" == "false" | "`covariates'" == "F" | "`covariates'" == "False" {
		qui jl: covariates = false
	}
	else { 
		display as error "Error: set covariates to true or false or omit the argument (defaults to false)"
	}
	
	// Parse save_all_csvs
	if  "`save_csv'" == "" | "`save_csv'" == "TRUE" | "`save_csv'" == "true" | "`save_csv'" == "T" | "`save_csv'" == "True" {
		qui jl: save_all_csvs = true
		di as result "Saving combined_diff_data.csv to " "`c(pwd)'"
	}
	else if "`save_csv'" == "FALSE" | "`save_csv'" == "false" | "`save_csv'" == "F" | "`save_csv'" == "False" {
		qui jl: save_all_csvs = false
	}
	else { 
		display as error "Error: set save_csv to true or false or omit the argument (defaults to true)"
	}
	
	// Parse interpolation
	if "`interpolation'" == "" | "`interpolation'" == "FALSE" | "`interpolation'" == "false" | "`interpolation'" == "F" | "`interpolation'" == "False" {
		qui jl: interpolation = false
	}
	else if "`interpolation'" == "linear_function"{
		qui jl: interpolation = "linear_function"
	}
	else{
		display as error "Error: currently the only supported options for interpolation and extrapolation for missing diff_estimates are: linear_function"
	}
		
	qui jl: results = run_stage_three("$folder", agg = agg, covariates = covariates, save_all_csvs = save_all_csvs, interpolation = interpolation)
	
	qui jl: if "ATT_g" in DataFrames.names(results) ///
				results.ATT_g = Float64.(results.ATT_g); ///
			end 
			
	qui jl: if "ATT_s" in DataFrames.names(results) ///
				results.ATT_s = Float64.(results.ATT_s); ///
			end 
			
	qui jl: if "ATT_gt" in DataFrames.names(results) ///
				results.ATT_gt = Float64.(results.ATT_gt); ///
			end 
	
	jl use results, clear	 
	
	di as result "Saving UNDID_results.csv to " "`c(pwd)'"
	
end 

/*--------------------------------------*/
/* Change Log */
/*--------------------------------------*/
*0.1.1 - changed column types from Any to Float64 to ensure data is passed to Stata properly and changed argument from save_all_csvs to save_csv and now defaults to true
*0.1.2 - display filepaths for saved .csv files
