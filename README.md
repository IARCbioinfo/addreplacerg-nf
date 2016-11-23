# Adds and replaces read group tags in BAM files

Apply [`samtools addreplacerg`](http://www.htslib.org/doc/samtools.html) to add a new read group and assign all reads to it in a set of BAM files using their names.

This scripts takes a set of [BAM files](https://samtools.github.io/hts-specs/) (called `*.bam`) grouped in a single folder as an input.

In each BAM file, the read group ID and SM fields will be set to BAM file name after removing the `.bam` extension. The command applied to each file is:
```bash
samtools addreplacerg -r "@RG\tID:file_name\tPG:samtools addreplacerg\tSM:file_name}"
```

## How to install

1. Install [java](https://java.com/download/) JRE if you don't already have it.

2. Install [nextflow](http://www.nextflow.io/).

	```bash
	curl -fsSL get.nextflow.io | bash
	```
	And move it to a location in your `$PATH` (`/usr/local/bin` for example here):
	```bash
	sudo mv nextflow /usr/local/bin
	```
	
3. Install [samtools](http://www.htslib.org/) 1.3 or above and add it to your path. Alternatively, you can use the docker image provided (see below).

## How to run

Simply use:
```bash
nextflow run iarcbioinfo/addreplacerg-nf --bam_folder BAM/
```

By default, BAM files produced are output in the same folder as the input folder. One can also specify the output folder by adding the optional argument `--out_folder BAM_RG` to the above command line for example.

If you don't have `samtools` you can use the docker image we provide containing it using:
```bash
nextflow run iarcbioinfo/addreplacerg-nf -with-docker --bam_folder BAM/
```

Installing [docker](https://www.docker.com) is very system specific (but quite easy in most cases), follow  [docker documentation](https://docs.docker.com/installation/). Also follow the optional configuration step called `Create a Docker group` in their documentation.

## Detailed instructions

The exact same pipeline can be run on your computer or on a HPC cluster, by adding a [nextflow configuration file](http://www.nextflow.io/docs/latest/config.html) to choose an appropriate [executor](http://www.nextflow.io/docs/latest/executor.html). For example to work on a cluster using [SGE scheduler](https://en.wikipedia.org/wiki/Oracle_Grid_Engine), simply add a file named `nextflow.config` in the current directory (or `~/.nextflow/config` to make global changes) containing:  
```java
process.executor = 'sge'
```

Other popular schedulers such as LSF, SLURM, PBS, TORQUE etc. are also compatible. See the nextflow documentation [here](http://www.nextflow.io/docs/latest/executor.html) for more details. Also have a look at the [other parameters for the executors](http://www.nextflow.io/docs/latest/config.html#scope-executor), in particular `queueSize` that defines the number of tasks the executor will handle in a parallel manner.  

The default number of tasks the executor will handle in a parallel is 100, which is certainly too high if you are executing it on your local machine. In this case a good idea is to set it to the number of computing cores your local machine has. Following is an example to create a config file with this information automatically (works on Linux and Mac OS X):
```bash
echo "executor.\$local.queueSize = "`getconf _NPROCESSORS_ONLN` > ~/.nextflow/config
```

Replace `>` by `>>` if you want to add the argument line to an existing nextflow config file.
