/*------------------------------------*/
/*create_diff_df*/
/*written by Eric Jamieson */
/*version 0.1.0 2024-08-27 */
/*------------------------------------*/
version 14.1

cap program drop create_diff_df
program define create_diff_df

	syntax , filepath(string) date_format(string) freq(string) [covariates(string) freq_multiplier(string) confine_matching(string)]
	
	// Declare usage of Undid and start up Julia
	jl: using Undid
	
	// Allow variables to be passed to Julia
	global filepath = "`filepath'"
	global date_format = "`date_format'"
	global freq = "`freq'"
	 
	// Parse covariates if necessary
	if "`covariates'" == ""{
		qui jl: covariates = false
	}
	else {
		qui jl: covariates = String[]
		local counter = 1
		tokenize "`covariates'"
		while "`1'" != "" {
            global covariate_to_julia "`1'"
			qui jl: push!(covariates, "$covariate_to_julia")
			local counter = `counter' + 1
			macro shift
		}
		
	}
	
	// Parse confine_matching
	if "`confine_matching'" == "" | "`confine_matching'" == "TRUE" | "`confine_matching'" == "true" | "`confine_matching'" == "T" | "`confine_matching'" == "True" {
		qui jl: confine_matching = true
	}
	else if  "`confine_matching'" == "FALSE" | "`confine_matching'" == "false" | "`confine_matching'" == "F" | "`confine_matching'" == "False" {
		qui jl: confine_matching = false
	}
	else { 
		display as error "Error: set confine_matching to true or false or omit the argument (defaults to true)"
	}
	
	// Parse freq_multiplier
	if "`freq_multiplier'" == "" | "`freq_multiplier'" == "false" | "`freq_multiplier'" == "False" | "`freq_multiplier'" == "FALSE" | "`freq_multiplier'" == "F" {
		qui jl: freq_multiplier = false
	}
	else {
		global freq_multiplier = "`freq_multiplier'"
		qui jl: freq_multiplier = "$freq_multiplier"
		qui jl: freq_multiplier = parse(Int, freq_multiplier)
	}

	
	jl: filepath = diff_df = create_diff_df("$filepath", covariates = covariates, date_format = "$date_format", freq = "$freq", freq_multiplier = freq_multiplier, confine_matching = confine_matching, return_filepath = true)

	// Return the filepath to Stata
	qui jl: st_global("filepath", filepath)	
	disp as result "empty_diff_df.csv saved to"
   	disp as result subinstr("$filepath", "\", "/", .)

end
