/*------------------------------------*/
/*undidjl_stage_three*/
/*written by Eric Jamieson */
/*version 0.1.0 2024-08-27 */
/*------------------------------------*/
version 14.1


cap program drop undidjl_stage_three
program define undidjl_stage_three

	syntax , folder(string) [agg(string) covariates(string) save_all_csvs(string) interpolation(string)]
	
	// Declare usage of Undid and start up Julia
	jl: using Undid
	
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
	if "`save_all_csvs'" == "TRUE" | 	"`save_all_csvs'" == "true" | "`save_all_csvs'" == "T" | "`save_all_csvs'" == "True" {
		qui jl: save_all_csvs = true
	}
	else if "`save_all_csvs'" == "" | "`save_all_csvs'" == "FALSE" | "`save_all_csvs'" == "false" | "`save_all_csvs'" == "F" | "`save_all_csvs'" == "False" {
		qui jl: save_all_csvs = false
	}
	else { 
		display as error "Error: set save_all_csvs to true or false or omit the argument (defaults to false)"
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
	
	jl use results, clear	 
	
end 