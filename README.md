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
4. **create_diff_df**: Creates a .csv file (empty_diff_df.csv) using information from the init.csv specifying the required differences to be calculated at each silo.

##### Examples
```stata
create_init_csv, silo_names("71 73 58 46") start_times("1989 1989 1989 1989") end_times("2000 2000 2000 2000") treatment_times("1991 control 1993 control") covariates("asian black male")
# init.csv saved to
# C:/Users/User/Documents/Project Files/init.csv


create_diff_df, filepath("C:/Users/User/Documents/Project Files/init.csv") date_format("yyyy") freq("yearly")
# empty_diff_df.csv saved to
# C:/Users/User/Documents/Project Files/empty_diff_df.csv
```
##### Details
Calling `create_init_csv` will return the filepath where the created init.csv is saved and its contents will appear in the active Stata dataset. All of the options for `create_init_csv` are optional and thus `create_init_csv` can be called to create a blank init.csv file with only the appropriate headers which can then be filled out manually. Dates can be entered in a wide variety of formats shown [here](#valid-date-formats). Ensure that dates are consistently entered in the same format when creating the init.csv. Control silos should be marked with "control" in the treatment_times column (e.g. silos 73 & 46 in the above example). Covariates can either be specified when creating the init.csv or when calling `create_diff_df`.

Likewise, calling `create_diff_df` will return the filepath where the created empty_diff_df.csv is saved and its contents will appear in the active Stata dataset. The required arguments are the filepath to the init.csv, the [date_format](#valid-date-formats) used in the init.csv and the frequency of the data being considered for the unpooled difference-in-differences analysis (daily, weekly, monthly, or yearly). If the frequency of data is not monthly, but quarterly, you can specify freq("monthly") and the optional argument freq_multiplier(3). If covariates is left blank, `create_diff_df` will simply take the covariates specified in the init.csv, otherwise specifying covariates when calling `create_diff_df` will override any covariate specifications made in the init.csv. 

## Stage Two: Silo
This command is used during the second stage of the undid process at each silo:

5. **undidjl_state_two**: Grabs information from the empty_diff_df.csv and the local silo data to fill out that silo's portion of the empty_diff_df.csv which is then saved as filled_diff_df_$local_silo_name.csv. Also computes trends data of the outcome of interest which is saved as trends_data_$local_silo_name.csv.

##### Examples
```stata
use "C:\Users\User\Data\State73.dta", clear
undidjl_stage_two, filepath("C:/Users/User/Documents/csvs/empty_diff_df.csv") local_silo_name("73") time_column("date_str") outcome_column("coll") local_date_format("ddmonyyyy") view_dataframe("trends")
# filled_diff_df_73.csv saved to
# C:/Users/User/Current Folder/filled_diff_df_73.csv
# trends_data_73.csv saved to
# C:/Users/User/Current Folder/trends_data_73.csv
```
##### Details
In order to run `undidjl_stage_two`, the local silo data must be loaded as the active dataset in Stata and any covariates specified in the empty_diff_df.csv should be renamed at the local silo to conform with the variable names used in the empty_diff_df.csv. The local_silo_name argument is used to specify how your local silo is named within the empty_diff_df.csv file and must correspond to how it is written there. The time_column and outcome_column arguments are used to indicate which variable in your active dataset is the outcome of interest and which variable indicates the date at which that outcome was recorded. It is important to note that the time_column should reference a string variable as passing a Stata date object to Julia does not work well. 

local_date_format specifies the [format](#valid-date-formats) of the date strings found in the time_column and is needed in order to parse the string to a date object within Julia. view_dataframe is set to "diff" if not specified but can be set to "trends" or "diff" and will return either the trends_data or the filled_diff_df to the active Stata dataset based on the selection, either way both dataframes are saved as .csv's. A final option is consider_covariates which is "true" by default but can be set to "false" if the covariates specified in Stage 1 do not exist at the local silo. 

## Stage Three: Analysis
These commands are used during the third and final stage of undid:

6. **undidjl_stage_three**: Computes aggregate ATT and standard error as well as ATTs by silo, g group, or gt group.
7. **plot_parallel_trends**: Plots parallel trends figures.





### Appendix

#### Valid Date Formats
- `ddmonyyyy` → 25aug1990
- `yyyym00` → 1990m8
- `yyyy/mm/dd` → 1990/08/25
- `yyyy-mm-dd` → 1990-08-25
- `yyyymmdd` → 19900825
- `yyyy/dd/mm` → 1990/25/08
- `yyyy-dd-mm` → 1990-25-08
- `yyyyddmm` → 19902508
- `dd/mm/yyyy` → 25/08/1990
- `dd-mm-yyyy` → 25-08-1990
- `ddmmyyyy` → 25081990
- `mm/dd/yyyy` → 08/25/1990
- `mm-dd-yyyy` → 08-25-1990
- `mmddyyyy` → 08251990
- `mm/yyyy` → 08/1990
- `mm-yyyy` → 08-1990
- `mmyyyy` → 081990
- `yyyy` → 1990

#### Undid Schematic 
![Diagram showing how difference-in-differences is computed with unpoolable data](./undid_schematic.png)

