/*------------------------------------*/
/*plot_parallel_trends*/
/*written by Eric Jamieson */
/*version 0.0.1 2024-09-03 */
/*------------------------------------*/
version 14.1


// 1) no covariates, one treated line and one control line
// 2) residualized by covariates, one treated line and one control line
// 2) no covariates, one line per silo
// 3) residualized by covariates, one line per silo

cap program drop plot_parallel_trends
program define plot_parallel_trends

	syntax , folder(string) outcome_variable(string) [silos(string) save_csv(string) covariates(string) save_image(string) omit_silos(string) date_format(string)]

	jl: using Undid
	
	// Allow variables to be passed to Julia
	qui global folder = "`folder'"
	qui global outcome_variable = "`outcome_variable'"
	
	// Parse save_csv
	if "`save_csv'" == "" | "`save_csv'" == "TRUE" | "`save_csv'" == "true" | "`save_csv'" == "T" | "`save_csv'" == "True" {
		qui jl: save_csv = true
	}
	else if "`save_csv'" == "FALSE" | "`save_csv'" == "false" | "`save_csv'" == "F" | "`save_csv'" == "False" {
		qui jl: save_csv = false
	}
	else { 
		display as error "Error: set save_csv to true or false or omit the argument (defaults to false)"
	}
	
	// Parse date_format options
	if "`date_format'" == "" | "`date_format'" == "tdCCYY" | "`date_format'" == "%tdCCYY" | "`date_format'" == "yearly"  {
		global date_format %tdCCYY
	}
	else if "`date_format'" == "tdMonYY" | "`date_format'" == "%tdMonYY" | "`date_format'" == "monthly"  {
		global date_format %tdMonYY
	}
	else if "`date_format'" == "tdDD-NN-CCYY" | "`date_format'" == "%tdDD-NN-CCYY" | "`date_format'" == "full_date"  {
		global date_format %tdDD-NN-CCYY
	}
	else if "`date_format'" == "%tdDDMon" | "`date_format'" == "tdDDMon" |  "`date_format'" == "day_and_month" {
		global date_format %tdDDMon
	}
	else {
		disp as error "Please specify the date_format for the x axis as either yearly, monthly, full_date, or day_and_month"
	}
	
	// Combine trends data and change column formats 
	// so that they can be transferred to Stata
	qui jl: trends_data = combine_trends_data("$folder", save_csv = save_csv)
	qui jl: trends_data.treatment_time = string.(trends_data.treatment_time) 
	qui jl: trends_data.time = string.(trends_data.time) 
	qui jl: trends_data.covariates = string.(trends_data.covariates) 
	qui jl: trends_data.mean_outcome = Float64.( trends_data.mean_outcome)
	qui jl: trends_data.treatment_period = coalesce.(trends_data.treatment_period, 0)
	qui jl: if trends_data.mean_outcome_residualized[1] == "n/a" /// 
	trends_data.mean_outcome_residualized = string.(trends_data.mean_outcome_residualized); ///
	else ///
	trends_data.mean_outcome_residualized = Float64.(trends_data.mean_outcome_residualized); ///
	end
	qui jl: select!(trends_data, Not([:freq, :date_format]))

	
	// Filter data to the relevant silos
	if "`silos'" == "" & "`omit_silos'" == ""{
		* do nothing
	}
	else if "`silos'" == "" & "`omit_silos'" != ""{
		global omit_silos = "`omit_silos'"
		qui jl: omit_silos = "$omit_silos"
		qui jl: omit_silos = split(omit_silos)
		qui jl: trends_data = filter(row -> !(row.silo_name in omit_silos), trends_data)
	} 
	else if "`silos'" != "" & "`omit_silos'" == ""{
		global silos = "`silos'"
		qui jl: silos = "$silos"
		qui jl: silos = split(silos)
		qui jl: trends_data = filter(row -> row.silo_name in silos, trends_data)
	}
	else {
		disp as error "Please either specify silos to keep using the silos argument, or specify silos to omit using the omit_silos argument."
	}
	
	// Determine if plot is with mean_outcome or mean_outcome_residualized
	if "`covariates'" == "TRUE" | "`covariates'" == "true" | "`covariates'" == "T" | "`covariates'" == "True" {
		qui jl: trends_data.y = trends_data.mean_outcome_residualized
		qui global resid = " (Residualized by Covariates)"
	}
	else if "`covariates'" == "" | "`covariates'" == "FALSE" | "`covariates'" == "false" | "`covariates'" == "F" | "`covariates'" == "False" {
		qui jl: trends_data.y = trends_data.mean_outcome
		qui global resid = ""
	}
	else {
		disp as error "To plot the mean_outcome set covariates to false. To plot the mean outcome residualized by covariates, set covariates to true."
	}
	
	// Load the Julia dataframe into Stata
	jl use trends_data, clear
	
	// Plot
	gen date = date(time, "YMD")
	format date %td
	encode silo_name, gen(silo_id)
	xtset silo_id date
	xtline y, overlay ///
    title("$outcome_variable$resid by Silo") ///
    ytitle("Average $outcome_variable$resid") ///
	xtitle("") ///
    xlabel(, format($date_format) labsize(small)) /// 
	ylabel(, labsize(small))
	


end 


/*--------------------------------------*/
/* Change Log */
/*--------------------------------------*/
*0.0.0 - initialized
*0.0.1 - working as a beta version
