/*------------------------------------*/
/*undidjl_stage_three*/
/*written by Eric Jamieson */
/*version 0.4.2 2024-12-09 */
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

	import delimited "UNDID_results.csv", varnames(1) clear
	
	// Convert att an se of the subset into generic variables
	qui capture confirm variable silo_n
	qui if !_rc {
		qui rename silo_n n_obs
		qui gen att_subset = att_s if !missing(att_s)
		qui gen att_subset_se = att_s_se if !missing(att_s_se)
		qui gen att_subset_se_jack = att_s_se_jackknife if !missing(att_s_se_jackknife)
	}
	
	qui capture confirm variable gt_n
	qui if !_rc {
		qui rename gt_n n_obs
		qui gen att_subset = att_gt if !missing(att_gt)
		qui gen att_subset_se = att_gt_se if !missing(att_gt_se)
		qui gen att_subset_se_jack = att_gt_se_jackknife if !missing(att_gt_se_jackknife)
	}
	
	qui capture confirm variable g_n
	qui if !_rc {
		qui rename g_n n_obs
		qui gen att_subset = att_g if !missing(att_g)
		qui gen att_subset_se = att_g_se if !missing(att_g_se)
		qui gen att_subset_se_jack = att_g_se_jackknife if !missing(att_g_se_jackknife)
	}
	
	qui capture confirm variable treatment_time
	qui if !_rc {
		tostring treatment_time, replace
	}
	
	qui capture confirm variable stderr
	qui if !_rc {
		qui gen agg_att_se = stderr if !missing(stderr)
	}
	
	
	
	
	qui capture confirm variable treatment_time
	qui if _rc == 0 {
		qui capture confirm variable dof
		qui if _rc == 0 {
			local deg_freedom = dof
			drop dof
		}
	}
	
	qui capture confirm variable n_obs 
	qui if _rc == 0 {
		gen p_value_subset = .
		gen p_value_subset_jack = .
		forvalues i = 1/`=_N' {
			local t_value = att_subset[`i'] / att_subset_se[`i']
			local df = n_obs[`i'] - 1
			replace p_value_subset = 2 * ttail(`df', abs(`t_value')) in `i'
			
			local t_value_jack = att_subset[`i'] / att_subset_se_jack[`i']
			local df_jack = jack_n[`i'] - 1
			replace p_value_subset_jack = 2 * ttail(`df_jack', abs(`t_value_jack')) in `i'
			
		}
	}
	
	qui capture confirm variable jackknife_se
	qui if _rc == 0 {
		local t_val = agg_att / jackknife_se
		if "`deg_freedom'" == "" {
			local deg_freedom = _N - 1
		}
		gen p_value_jackknife = .
		replace p_value_jackknife = 2*ttail(`deg_freedom', abs(`t_val')) if !missing(jackknife_se)
		order p_value_jackknife, after(jackknife_se)
	}
	

	local t_val = agg_att / agg_att_se
	if "`deg_freedom'" == "" {
		local deg_freedom = _N - 1
	}
	gen p_value = .
	replace p_value = 2*ttail(`deg_freedom', abs(`t_val')) if !missing(agg_att_se)
	order p_value, after(agg_att_se)

	
	
	
	di as result "Saving UNDID_results.csv to " "`c(pwd)'"
	
	qui count
	local N = r(N)
	local condition_met 0
	
	qui capture confirm variable att_s
	if _rc == 0 & `condition_met' == 0 {
		local condition_met 1
		di as text "-------------------------------------------------------------------------------------------"
		di as text "                                       UNDID Results                    "
		di as text "-------------------------------------------------------------------------------------------"
		di as text "Silo                      | " as text "ATT             | SE     | p-val  | JKNIFE SE  | JKNIFE p-val |"
		di as text "--------------------------|-----------------|--------|--------|------------|--------------|"
		forvalues i = 1/`N' {
			di as text %-25s "`=silos[`i']'" as text " |" as result %-16.7f att_s[`i'] as text " | " as result  %-7.3f att_subset_se[`i'] as text "| " as result %-7.3f p_value_subset[`i'] as text "| " as result  %-11.3f att_subset_se_jack[`i'] as text "| " as result %-13.3f p_value_subset_jack[`i'] as text "|"
    
			di as text "--------------------------|-----------------|--------|--------|------------|--------------|"
		}
		di as text "Aggregation: " as result "silo"
		di as text "Aggregate ATT: " as result agg_att[1]
		di as text "Standard error: " as result agg_att_se[1]
		di as text "p-value: " as result p_value[1]
		di as text "Jackknife SE: " as result jackknife_se[1]
		di as text "Jackknife p-value: " as result p_value_jackknife[1]
		di as text "RI p-value: " as result p_value_ri[1]
	} 
	
	qui capture confirm variable att_gt
	if _rc == 0 & `condition_met' == 0 {
		local condition_met 1
		di as text "-------------------------------------------------------------------------------------------"
		di as text "                                       UNDID Results                    "
		di as text "-------------------------------------------------------------------------------------------"
		di as text "(g,t)                     | " as text "ATT             | SE     | p-val  | JKNIFE SE  | JKNIFE p-val |"
			di as text "--------------------------|-----------------|--------|--------|------------|--------------|"
		forvalues i = 1/`N' {
			di as text %-25s "`=gt[`i']'" as text " |" as result %-16.7f att_gt[`i'] as text " | " as result  %-7.3f att_subset_se[`i'] as text "| " as result %-7.3f p_value_subset[`i'] as text "| " as result  %-11.3f att_subset_se_jack[`i'] as text "| " as result %-13.3f p_value_subset_jack[`i'] as text "|"
    
			di as text "--------------------------|-----------------|--------|--------|------------|--------------|"
		}
		di as text "Aggregation: " as result "gt"
		di as text "Aggregate ATT: " as result agg_att[1]
		di as text "Standard error: " as result agg_att_se[1]
		di as text "p-value: " as result p_value[1]
		di as text "Jackknife SE: " as result jackknife_se[1]
		di as text "Jackknife p-value: " as result p_value_jackknife[1]
		di as text "RI p-value: " as result p_value_ri[1]
	} 
	
	qui capture confirm variable att_g
	if _rc == 0 & `condition_met' == 0 {
		local condition_met 1
		di as text "-------------------------------------------------------------------------------------------"
		di as text "                                       UNDID Results                    "
		di as text "-------------------------------------------------------------------------------------------"
		di as text "g                         | " as text "ATT             | SE     | p-val  | JKNIFE SE  | JKNIFE p-val |"
		di as text "--------------------------|-----------------|--------|--------|------------|--------------|"
		forvalues i = 1/`N' {
			di as text %-25s "`=g[`i']'" as text " |" as result %-16.7f att_g[`i'] as text " | " as result  %-7.3f att_subset_se[`i'] as text "| " as result %-7.3f p_value_subset[`i'] as text "| " as result  %-11.3f att_subset_se_jack[`i'] as text "| " as result %-13.3f p_value_subset_jack[`i'] as text "|"
    
			di as text "--------------------------|-----------------|--------|--------|------------|--------------|"
		}
		di as text "Aggregation: " as result "g"
		di as text "Aggregate ATT: " as result agg_att[1]
		di as text "Standard error: " as result agg_att_se[1]
		di as text "p-value: " as result p_value[1]
		di as text "Jackknife SE: " as result jackknife_se[1]
		di as text "Jackknife p-value: " as result p_value_jackknife[1]
		di as text "RI p-value: " as result p_value_ri[1]
	}
	
	qui capture confirm variable treatment_time
	if _rc == 0 & `condition_met' == 0 {		
		local condition_met 1
		di as text "------------------------------------------------------"
		di as text "                     UNDID Results                    "
		di as text "------------------------------------------------------"
		di as text "Common Treatment Time: " as result treatment_time[1]
		di as text "------------------------------------------------------"
		di as text "Aggregate ATT: " as result agg_att[1]
		qui capture confirm variable agg_att_se
		if _rc == 0 {
			di as text "Standard error: " as result agg_att_se[1]
			di as text "p-value: " as result p_value[1]
		}
		qui capture confirm variable jackknife_se
		if _rc == 0 {
			di as text "Jackknife SE: " as result jackknife_se[1]
			di as text "Jackknife p-value: " as result p_value_jackknife[1]
		}
		qui capture confirm variable se_column
		if _rc == 0 {
			drop p_value_ri
			di as text "Standard error: " as result stderr[1]
			qui local t_val = agg_att / stderr
			qui gen p_value = 2*ttail(1, abs(`t_val'))
			di as text "p-value: " as result p_value[1]
		}
		else {
			di as text "RI p-value: " as result p_value_ri[1]
		}
		
	}
	
	qui capture confirm variable att_subset
	if _rc == 0 {
		drop att_subset
		drop att_subset_se
		drop att_subset_se_jack
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
*0.3.0 - added computation of jackknife p -value for common treatment with silos >= 3
*0.4.0 - added new se's and p-vals
*0.4.1 - made correction to dof
*0.4.2 - enhanced robustness
