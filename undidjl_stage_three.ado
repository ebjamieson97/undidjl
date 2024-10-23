/*------------------------------------*/
/*undidjl_stage_three*/
/*written by Eric Jamieson */
/*version 0.2.0 2024-10-23 */
/*------------------------------------*/
version 14.1


cap program drop undidjl_stage_three
program define undidjl_stage_three

	syntax , folder(string) [agg(string) covariates(string) save_csv(string) interpolation(string) weights(string)]
	
	// Declare usage of Undid and start up Julia
	jl: using Undid
	jl: using DataFrames
	
	// Allow variables to be passed to Julia
	global folder = subinstr("`folder'", "\", "/", .)

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
	
	// Parse weights
	if "`weights'" == "" | "`weights'" == "true" | "`weights'" == "True" | "`weights'" == "TRUE" | "`weights'" == "T" | "`weights'" == "on" | "`weights'" == "ON" | "`weights'" == "On" {
		qui jl: weights = true
	}
	else if "`weights'" == "FALSE" | "`weights'" == "F" | "`weights'" == "false" | "`weights'" == "False" | "`weights'" == "off" | "`weights'" == "OFF" | "`weights'" == "Off" {
		qui jl: weights = false
	}
	else { 
		di as error `"Please set weights to either "true" or "false"."'
	}
		
	qui jl: results = run_stage_three("$folder", agg = agg, covariates = covariates, save_all_csvs = save_all_csvs, interpolation = interpolation, weights = weights)
	
	qui jl: if "ATT_g" in DataFrames.names(results) ///
				results.ATT_g = Float64.(results.ATT_g); ///
			end 
			
	qui jl: if "ATT_s" in DataFrames.names(results) ///
				results.ATT_s = Float64.(results.ATT_s); ///
			end 
			
	qui jl: if "ATT_gt" in DataFrames.names(results) ///
				results.ATT_gt = Float64.(results.ATT_gt); ///
			end 
			
	qui jl: if "treatment_time" in DataFrames.names(results) ///
				results.treatment_time = string.(results.treatment_time); ///
			end 
			
	
	jl use results, clear	 
	
	qui capture confirm variable treatment_time
	qui if _rc == 0 {
		qui capture confirm variable jackknife_SE 
		qui if _rc == 0 {
			local num_obs = num_silos
			drop num_silos
		}
	}
	
	qui capture confirm variable jackknife_SE
	qui if _rc == 0 {
		local t_val = agg_ATT / jackknife_SE
		if "`num_obs'" == "" {
			local num_obs = _N
		}
		gen p_value_jackknife = .
		replace p_value_jackknife = 2*ttail(`num_obs'-1, abs(`t_val')) if !missing(jackknife_SE)
		order p_value_jackknife, after(jackknife_SE)
	}
	
	
	
	di as result "Saving UNDID_results.csv to " "`c(pwd)'"
	
	qui count
	local N = r(N)
	local condition_met 0
	
	qui capture confirm variable ATT_s
	if _rc == 0 & `condition_met' == 0 {
		local condition_met 1
		di as text "------------------------------------------------------"
		di as text "                     UNDID Results                    "
		di as text "------------------------------------------------------"
		di as text "Silo                      | " as text "ATT                      |"
		di as text "--------------------------|--------------------------|"
		forvalues i = 1/`N' {
			di as text %-25s "`=silos[`i']'" as text " |" as result %-25.7f ATT_s[`i'] as text " |"
    
			di as text "--------------------------|--------------------------|"
		}
		di as text "Aggregation: " as result "silo"
		di as text "Aggregate ATT: " as result agg_ATT[1]
		di as text "Jackknife SE: " as result jackknife_SE[1]
		di as text "Jackknife p-value: " as result p_value_jackknife[1]
		di as text "RI p-value: " as result p_value_RI[1]
	} 
	
	qui capture confirm variable ATT_gt
	if _rc == 0 & `condition_met' == 0 {
		local condition_met 1
		di as text "------------------------------------------------------"
		di as text "                     UNDID Results                    "
		di as text "------------------------------------------------------"
		di as text "(g,t)                     | " as text "ATT                      |"
		di as text "--------------------------|--------------------------|"
		forvalues i = 1/`N' {
			di as text %-25s "`=gt[`i']'" as text " |" as result %-25.7f ATT_gt[`i'] as text " |"
    
			di as text "--------------------------|--------------------------|"
		}
		di as text "Aggregation: " as result "gt"
		di as text "Aggregate ATT: " as result agg_ATT[1]
		di as text "Jackknife SE: " as result jackknife_SE[1]
		di as text "Jackknife p-value: " as result p_value_jackknife[1]
		di as text "RI p-value: " as result p_value_RI[1]
	} 
	
	qui capture confirm variable ATT_g
	if _rc == 0 & `condition_met' == 0 {
		local condition_met 1
		di as text "------------------------------------------------------"
		di as text "                     UNDID Results                    "
		di as text "------------------------------------------------------"
		di as text "g                         | " as text "ATT                      |"
		di as text "--------------------------|--------------------------|"
		forvalues i = 1/`N' {
			di as text %-25s "`=g[`i']'" as text " |" as result %-25.7f ATT_g[`i'] as text " |"
    
			di as text "--------------------------|--------------------------|"
		}
		di as text "Aggregation: " as result "g"
		di as text "Aggregate ATT: " as result agg_ATT[1]
		di as text "Jackknife SE: " as result jackknife_SE[1]
		di as text "Jackknife p-value: " as result p_value_jackknife[1]
		di as text "RI p-value: " as result p_value_RI[1]
	}
	
	qui capture confirm variable treatment_time
	if _rc == 0 & `condition_met' == 0 {
		local condition_met 1
		di as text "------------------------------------------------------"
		di as text "                     UNDID Results                    "
		di as text "------------------------------------------------------"
		di as text "Common Treatment Time: " as result treatment_time[1]
		di as text "------------------------------------------------------"
		di as text "Aggregate ATT: " as result agg_ATT[1]
		qui capture confirm variable jackknife_SE
		if _rc == 0 {
			di as text "Jackknife SE: " as result jackknife_SE[1]
			di as text "Jackknife p-value: " as result p_value_jackknife[1]
		}
		qui capture confirm variable SE
		if _rc == 0 {
			drop p_value_RI
			di as text "Standard Error: " as result SE[1]
			qui local t_val = agg_ATT / SE
			qui gen p_value = 2*ttail(1, abs(`t_val'))
			di as text "p-value: " as result p_value[1]
		}
		else {
			di as text "RI p-value: " as result p_value_RI[1]
		}
		
	}
	
end 

/*--------------------------------------*/
/* Change Log */
/*--------------------------------------*/
*0.1.1 - changed column types from Any to Float64 to ensure data is passed to Stata properly and changed argument from save_all_csvs to save_csv and now defaults to true
*0.1.2 - display filepaths for saved .csv files
*0.1.3 - backslashes to forwardslashes fixes Julia-Stata compatability issue
*0.1.4 - added p-values and output displays
*0.2.0 - added weights parameter
