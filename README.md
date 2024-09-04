# undidjl
This Stata package acts as a wrapper for the Julia package Undid.jl. 

Undid allows for estimation of difference-in-differences with unpoolable data, see https://arxiv.org/abs/2403.15910 for more details.

## Installation 
```
net install undidjl, from("https://raw.githubusercontent.com/ebjamieson97/undidjl/main/")
```
## Requirements
* Julia 1.9.4 or later
* Stata 14.1 or later
* the julia package for Stata, see https://github.com/droodman/julia.ado

### Utility Commands
These commands allow for managing the Undid.jl package for Julia from Stata:

1. **checkundidversion**: Displays the currently installed Undid.jl version number and the latest Undid.jl version number. Installs the latest version of Undid.jl if no version of Undid.jl is currently installed.
2. **updateundid**: Updates Undid.jl to the latest version if Undid.jl is already installed.


## Stage One: Initialize
These commands are used during the first stage of the undid process:

3. **create_init_csv**: Creates an initial .csv file (init.csv) specifying the silos, start times, end times, and treatment (or lack thereof) times.
4. **create_diff_df**: Creates an empty .csv file (empty_diff_df.csv) using information from the init.csv specifying the required differences to be calculated at each silo.

## Stage Two: Silo
This command is used during the second stage of the undid process at each silo:

5. **undidjl_state_two**: Grabs information from the empty_diff_df.csv and the local silo data to fill out that silo's portion of the empty_diff_df.csv which is then saved as filled_diff_df_$local_silo_name.csv. Also computes trends data of the outcome of interest which is saved as trends_data_$local_silo_name.csv.

## Stage Three: Analysis
These commands are used during the third and final stage of undid:

6. **undidjl_stage_three**: Executes the third stage of undid.
7. **plot_parallel_trends**: Plots the parallel trends figures.



### Undid Schematic 
![Diagram showing how difference-in-differences is computed with unpoolable data](./undid_schematic.png)
