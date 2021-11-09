module load scorep scalasca cube vampir

# cf. https://kb.hlrs.de/platforms/index.php/Score-P
export SCOREP_ENABLE_TRACING=true # enable to generate otf2 tracefiles for vampir, best check overhead before with PROFILING

export SCOREP_ENABLE_PROFILING=false # enable to generate cubex profile for CUBE

# export SCOREP_FILTERING_FILE=<filter file> # specify filter file to reduce overheads if necessary

export SCOREP_MPI_MAX_COMMUNICATORS=5000


export MPI_SHEPHERD=true # needed for MPT on HAWK
