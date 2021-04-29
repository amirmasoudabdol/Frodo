# Frodo

Frodo is a collection of scripts that facilitates the process of creating, managing and running SAM projects. 

## Requirement

Frodo is mainly written in [GNU Make](https://www.gnu.org/software/make/) and it should be available on most operation systems by default. On Windows, you may either install [Cygwin](https://www.cygwin.com) or if you are running newer version of Windows, e.g., Windows 10, you may install the [Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/). Alternatively, if you find the method above tedious, you may opt for installing the [Anaconda](https://www.anaconda.com) package to get most of the tools needed to run Frodo and its dependent scripts. This is a valid alternative on all three mainstream operation systems if you do not currently have a development environment ready, or do not know how to set it up correctly. Often installing Anaconda is enough to get a proper and well-functioning scientific development environment.

## Getting Started with Frodo

After successfully installing Anaconda, you can download the Anaconda from GitHub using:

```bash
git clone https://github.com/amirmasoudabdol/Frodo.git
```

After this, `cd` into the Frodo folder, and simple run `make`. This should show some helpful information about available commands and parameters, like below:

```
❯ make

 This is SAMoo, a handy toolset for preparing a new project using SAM.
 In the process of 'prepare'-ing a new project, this Makefile produces
 several template files for configuring and running a SAM project on
 your local machine or on Lisa cluster.

 Make sure that this Makefile knows where SAM and other
 dependencies are located. You can set their path through the
 parameters defined in line 9 – 12 of the Makefile.

Usage:
  make <target> parameter=value
  help             Display this help

  [Parameters]
  project          Project name
  path             Project path, defaults to ./projects/

-----------------------------------------------------------

Build
  prepare          Create a new project by running <config> and <sam>
  config           Building necessary files and folders for a new project
  sam              Build SAMrun executable. Note: This will update SAM source directory and rebuild it
  compress         Zip everything in the <project>

Cleanup
  clean            Remove all output files, i.e., configs, outputs, logs, jobs
  veryclean        Remove all project files
  remove           Delete the entire project directory

Example Usage:
    make prepare project=apollo path=HOME/Projects/
    make remove  project=apollo
```

As it is shown, there are a few things that you can do. Start by preparing a project, and observe the output. For instance, `make prepare project=apollo`. This creates a folder in the `projects/` folder named `apollo`, and populates it with files and scripts necessary for running a SAM simulation. 


## Working with SAM Projects

After preparing a SAM project, you can head into the `projects/apollo`, and observe all the files created by Frodo for you projects. Here, you can again run the `make` command and you will be welcomed by another set of handy commands and parameters.

```
❯ make
 You can control your project using this Makefile. There are several
 commands are available for running your simulation locally or on a
 cluster. It's also possible to run the simulation sequentially or in
 parallel on your local machine.

Usage:
  make <target>
  help             Display this help

[Paramters]
  using            Path to a new parameter generator
  name             The name of the archive

--------------------------------------------------------------

Build
  sam-build        Rebuild the binaries, run this if you've modified the code
  parameters       Preparing config files for SAM

Post-processing
  csv              Create a set of files `*_prepared.csv` by adding all keys/values to them. Use this when the database is too big
  stack            Stack several CSV files into one CSV file
  stacker          Faster version of stacker. Use this for lager data files
  database         Aggregate output files into a SQLite database
  summary          Runinng the `post-processing.R` script on every file in output/ folder

Run
  run-seq-local    Running the simulation sequentially on the local machine
  run-par-local    Running the simulation in parallel on the local machine
  run-par-lisa     Running the simulation in parallel on the Lisa cluster
  run-par-lisa-batch  Running the simulation in parallel on the Lisa cluster

Packaging
  archive          Archiving the entire project directory to ../marjan_2012_all_test_archive/archive/CUREENT_DATE_TIME or ../marjan_2012_all_test_analysis/archive/<name>
  compress         Compress the outputs/*, logs/* and configs/*

Cleanup
  clean            Remove most project specific files, configs, jobs, logs, etc.
  veryclean        Remove all project files, including outputs

Example Usage:
    make parameters using=~/projects_config/2012_project.py
    make run-seq-local; make archive name=Feb_5.zip
```

Here, Frodo turns into a project management tool and helps you configure and run your simulation, as well as exporting and archiving your results. For instance, if you have already `load`ed your project in the previous step, you can ask Frodo to use the already copied scripts to generate all the configuration files necessary for your simulation. 

```bash
make parameters
make run-seq-local
```

The first line creates a new folder, `configs/`, and populates it with all the configuration files based on the specification of the `apollo_prepare_config_files.py`. After this, the second command will execute SAM on all the configuration files available in the `configs/` folder and saves SAM's output files into the `outputs/` as it goes through the files one by one.