/*------------------------------------*/
/*create_diff_df*/
/*written by Eric Jamieson */
/*version 0.1.3 2024-09-06 */
/*------------------------------------*/
version 14.1

cap program drop create_diff_df
program define create_diff_df

	syntax , filepath(string) date_format(string) freq(string) [covariates(string) freq_multiplier(string) confine_matching(string)]
	
	// Declare usage of Undid and start up Julia
	jl: using Undid
	
	// Allow variables to be passed to Julia
	global filepath = subinstr("`filepath'", "\", "/", .)
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

	
	qui jl: outputs = create_diff_df("$filepath", covariates = covariates, date_format = "$date_format", freq = "$freq", freq_multiplier = freq_multiplier, confine_matching = confine_matching)
	qui jl: filepath = outputs[1]
	qui jl: empty_diff_df = string.(outputs[2])
	qui jl: rename!(empty_diff_df, Symbol("(g;t)") => :gt)

	// Return the filepath to Stata
	qui jl: st_global("filepath", filepath)	
	disp as result "empty_diff_df.csv saved to"
   	disp as result subinstr("$filepath", "\", "/", .)
	
	jl use empty_diff_df, clear


end
/*--------------------------------------*/
/* Change Log */
/*--------------------------------------*/
*0.1.1 - now returns the df to active Stata dataset, as well as prints out empty_diff_df.csv filepath
*0.1.2 - Stata can't handle (g;t) name for column so renamed to gt
*0.1.3 - converts and backslashes to forwardslashes for better compatability between Julia and Stata
