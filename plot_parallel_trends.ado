/*------------------------------------*/
/*plot_parallel_trends*/
/*written by Eric Jamieson */
/*version 0.0.0 2024-08-29 */
/*------------------------------------*/
version 14.1


// 1) no covariates, one treated line and one control line
// 2) residualized by covariates, one treated line and one control line
// 2) no covariates, one line per silo
// 3) residualized by covariates, one line per silo

cap program drop plot_parallel_trends
program define plot_parallel_trends

	syntax , folder(string) silos(string) [save_csv(string) covariates(string) save_image(string) omit_silos(string)]

	jl: using Undid
	
	// Allow variables to be passed to Julia
	global folder = "`folder'"
	
	// Parse save_csv
	if "`save_csv'" == "TRUE" | "`save_csv'" == "true" | "`save_csv'" == "T" | "`save_csv'" == "True" {
		qui jl: save_csv = true
	}
	else if "`save_csv'" == "" | "`save_csv'" == "FALSE" | "`save_csv'" == "false" | "`save_csv'" == "F" | "`save_csv'" == "False" {
		qui jl: save_csv = false
	}
	else { 
		display as error "Error: set save_csv to true or false or omit the argument (defaults to false)"
	}
	
	jl: trends_data = combine_trends("$folder", save_csv = save_csv)
	
	
	 

end 


/*--------------------------------------*/
/* Change Log */
/*--------------------------------------*/
*0.0.0 - initialized
