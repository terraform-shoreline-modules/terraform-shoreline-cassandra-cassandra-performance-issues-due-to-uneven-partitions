

#!/bin/bash



# set variables

cassandra_dir=${PATH_TO_CASSANDRA_DIR}

nodetool_dir=${PATH_TO_NODETOOL_DIR}



# stop Cassandra service

sudo service cassandra stop



# run nodetool repair command

sudo $cassandra_dir/$nodetool_dir/nodetool repair -pr



# start Cassandra service

sudo service cassandra start