/*------------------------------------*/
/*checkundidversion*/
/*written by Eric Jamieson */
/*version 0.1.1 2024-08-27 */
/*------------------------------------*/
version 14.1

cap program drop checkundidversion
program define checkundidversion

	// Check that David Roodman's Julia package for Stata is installed
	cap which jl
	if _rc {
    	di as error "The 'julia' package is required but not installed or not found in the system path. See https://github.com/droodman/julia.ado for more details."
    	exit 198
	} 
	
	// Check that Undid for Julia is installed
	jl: using Pkg
	jl: if Base.find_package("Undid") === nothing 				///
			SF_display("Undid.jl not installed, installing now.");  ///
			Pkg.add(url="https://github.com/ebjamieson97/Undid.jl"); ///
			SF_display("Undid.jl is done installing.");             ///
		end										         			

	// Report the currently installed version of Undid.jl
	qui jl: deps = Pkg.dependencies()
	qui jl: package_version = deps[Base.UUID("b4918ae7-7c73-4176-80be-8405760cf2ee")].version
	qui jl: current_Undid_version = string(package_version)
	qui jl: st_global("current_Undid_version", current_Undid_version)
	disp as result "Currently installed version of Undid.jl is: $current_Undid_version"

	qui jl: using Downloads
	qui jl: url = "https://raw.githubusercontent.com/ebjamieson97/Undid.jl/main/Project.toml"
	qui jl: try ///
		content = Downloads.download(url); ///
		file_content = read(content, String); ///
		start_pos = findfirst("version = ", file_content); ///
		start = start_pos[end]; /// 
		newest_version = file_content[start+2:start+6]; ///
		st_global("newest_version", newest_version); ///
	catch e ///
		println("An error occurred: ", e); ///
		st_global("newest_version", "Unable to fetch latest version of Undid.jl. Please check your internet connection and try again."); ///
	end 
	
	disp as result "Latest version of Undid.jl is: $newest_version"
	disp as result "Consider running command updateundid if installed version it out of date."

	
end

/*--------------------------------------*/
/* Change Log */
/*--------------------------------------*/
*0.0.3 - fixed Pkg.add url and set version to 14.1
*0.1.0 - changed results to disp as result 
*0.1.1 - added script to get latest version of Undid.jl from the associated .toml file
