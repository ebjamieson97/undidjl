/*------------------------------------*/
/*create_init_csv*/
/*written by Eric Jamieson */
/*version 0.1.0 2024-08-27 */
/*------------------------------------*/
version 14.1

cap program drop create_init_csv
program define create_init_csv

	syntax [, silo_names(string) start_times(string) end_times(string) treatment_times(string) covariates(string)]
	
	// Arguments are all optional, creates an empty .csv by default
	// Otherwise length of silo_names, start_times, end_times and treatment_times must be equal
	jl: using Undid
	
	// Parse covariates if included
	if "`covariates'" == "" {
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
	
	// Create init.csv and parse optional arguments if required
	if "`silo_names'" == "" | "`start_times'" == "" | "`end_times'" == "" | "`treatment_times'" == ""{ 
		qui jl: filepath = create_init_csv()
	}
	else {
		qui jl: names = String[]
		local counter = 1
		tokenize "`silo_names'"
		while "`1'" != "" {
            global silo_names_to_julia "`1'"
			qui jl: push!(names, "$silo_names_to_julia")
			local counter = `counter' + 1
			macro shift
		}
		qui jl: start_times = String[]
		local counter = 1
		tokenize "`start_times'"
		while "`1'" != "" {
            global start_times_to_julia "`1'"
			qui jl: push!(start_times, "$start_times_to_julia")
			local counter = `counter' + 1
			macro shift
		}
		qui jl: end_times = String[]
		local counter = 1
		tokenize "`end_times'"
		while "`1'" != "" {
            global end_times_to_julia "`1'"
			qui jl: push!(end_times, "$end_times_to_julia")
			local counter = `counter' + 1
			macro shift
		}
		qui jl: treatment_times = String[]
		local counter = 1
		tokenize "`treatment_times'"
		while "`1'" != "" {
            global treatment_times_to_julia "`1'"
			qui jl: push!(treatment_times, "$treatment_times_to_julia")
			local counter = `counter' + 1
			macro shift
		}
		qui jl: filepath = create_init_csv(names, start_times, end_times, treatment_times, covariates = covariates)
	}
	
	// Return the filepath to Stata
	qui jl: st_global("filepath", filepath)
	disp as result "init.csv saved to"
    disp as result "$filepath"
	
end 