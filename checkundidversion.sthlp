{smcl}
{* *! version 0.1.2 29aug2024}
{help checkundidversion:checkundidversion}
{hline}

{title:undidjl}

{pstd}
undidjl - Stata wrapper for the Undid.jl Julia package.{p_end}

{title:Command Description}

{phang}
{cmd:checkundidversion} checks if the Undid.jl Julia package is installed and reports the currently installed version. If it is not installed, the command installs the most recent version from {browse "https://github.com/ebjamieson97/Undid.jl"}.

{title:Examples}

{phang2}{txt:Input:}
{cmd:checkundidversion}

{phang2}{txt:Output:}
{txt}Currently installed version of Undid.jl is: 0.1.18
{txt}Latest version of Undid.jl is: 0.1.18
{txt}Consider running command updateundid if installed version is out of date.

{title:Author}

{pstd}
Eric Jamieson{p_end}

{pstd}
For more information about undidjl, visit the {browse "https://github.com/ebjamieson97/undidjl"} GitHub repository.{p_end}

{title:Citation}

{pstd}
Please cite: Sunny Karim, Matthew D. Webb, Nichole Austin, Erin Strumpf. 2024. Difference-in-Differenecs with Unpoolable Data. {browse "https://arxiv.org/abs/2403.15910"}  {p_end}
