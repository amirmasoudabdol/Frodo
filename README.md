# SAMoo

SAMoo is an attempt to use git for tracking the evolution of shell scripts used for running different simulation as well as different configuration files and even different simulations. Basically, I would like to create a branch, or tag for each simulation. This will allow me to carefully log the setup and parameters of a specific simulation.


## Steps

- `make prepare PROJECT=<your_project_name>`
	- *This will prepare all necessary directories, etc., as well as the executable of SAM.*
	
- `cd <your_project_name>`
- Modify the `<your_project_name>_params_grid_generator.R`
- Run `./<your_project_name>_params_grid_generator.R`

