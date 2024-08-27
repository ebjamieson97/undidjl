*! version 0.0.1 27aug2024
.- undidjl -.

Title
-----
undidjl - Stata wrapper for the Undid.jl Julia package

Description
-----------
`undidjl` provides a Stata interface for interacting with the Undid.jl package, which is a Julia package used for computing difference-in-differences with unpoolable data.

Syntax
------
    checkundidversion

Description
-----------
`checkundidversion` checks if the Undid.jl Julia package is installed and reports the current installed version. If it is not installed it installs the most recent version from https://github.com/ebjamieson97/Undid.jl. 

Example
-------
To check the version of Undid.jl:

    . checkundidversion

This command will display the currently installed version of the Undid.jl package, if available.

Author
------
Eric Jamieson

See Also
--------
For more information about Undid.jl, visit the [GitHub repository](https://github.com/ebjamieson97/undidjl).
