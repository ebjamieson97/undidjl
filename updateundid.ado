/*------------------------------------*/
/*checkundidversion*/
/*written by Eric Jamieson */
/*version 0.1.0 2024-08-29 */
/*------------------------------------*/
version 14.1

cap program drop updateundid
program define updateundid

	// Check that David Roodman's Julia package for Stata is installed
	cap which jl
	if _rc {
    	di as error "The 'julia' package is required but not installed or not found in the system path. See https://github.com/droodman/julia.ado for more details."
    	exit 198
	} 
	
	jl: using Pkg
	jl: Pkg.rm("Undid")
	jl: Pkg.add(url="https://github.com/ebjamieson97/Undid.jl")

end