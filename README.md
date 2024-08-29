# undidjl
This Stata package acts as a wrapper for the Julia package Undid.jl.

## Installation 
```
net install undidjl, from("https://raw.githubusercontent.com/ebjamieson97/undidjl/main/")
```

### Utility Commands
These commands provide general utilities for managing the Undid.jl package from Stata:

1. **checkundidversion**: Checks the current version of Undid.jl.
2. **updateundid**: Updates Undid.jl to the latest version.

## Stage One Commands
These commands are used during the first stage of the undid process:

3. **create_init_csv**: Creates an initial .csv file (init.csv) specifying the silos, start times, end times, and treatment (or lack thereof) times.
4. **create_diff_df**: Creates an empty .csv file (empty_diff_df.csv) using information from the init.csv specifying the required differences to be calculated at each silo.

## Stage Two Command
This command is used during the second stage of the undid process at each silo:

5. **undidjl_state_two**: Grabs information from the empty_diff_df.csv and the local silo data to fill out that silo's portion of the empty_diff_df.csv which is then saved as filled_diff_df_$local_silo_name.csv. Also computes trends data of the outcome of interest which is saved as trends_data_$local_silo_name.csv.

## Stage Three Commands
These commands are used during the third and final stage of undid:

6. **undidjl_stage_three**: Executes the third stage of undid.
7. **plot_parallel_trends**: Plots the parallel trends figures.

