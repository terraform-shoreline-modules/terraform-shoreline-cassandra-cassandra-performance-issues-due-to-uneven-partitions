
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Cassandra Performance Issues Due to Uneven Partitions
---

This incident type pertains to identifying uneven partitions in a Cassandra database, which can cause performance issues related to read/write operations and query execution. Cassandra is a distributed database that stores data across multiple nodes, and partitions are used to distribute the data evenly among the nodes. However, if the partition sizes are uneven, some nodes may become overloaded while others remain underutilized, leading to performance bottlenecks. Identifying these uneven partitions is crucial in ensuring optimal performance of the Cassandra database.

### Parameters
```shell
export CASSANDRA_NODE="PLACEHOLDER"

export KEYSPACE="PLACEHOLDER"

export TABLE="PLACEHOLDER"

export PATH_TO_CASSANDRA_DIR="PLACEHOLDER"

export PATH_TO_NODETOOL_DIR="PLACEHOLDER"
```

## Debug

### Connect to Cassandra cluster
```shell
cqlsh ${CASSANDRA_NODE}
```

### Check if nodetool is installed
```shell
nodetool status
```

### Check the token ranges for each node
```shell
nodetool ring
```

### Identify the highest and lowest token values
```shell
nodetool ring | awk '{print $NF, $8}' | sort | awk 'NR==1{print "Lowest Token:", $1}; END{print "Highest Token:", $1}'
```

### Check the size of each partition
```shell
nodetool cfstats ${KEYSPACE}.${TABLE} | grep "Partition Size"
```

### Identify the largest and smallest partitions
```shell
nodetool cfstats ${KEYSPACE}.${TABLE} | grep "Partition Size" | awk '{print $3, $4}' | sort -k2 -n | awk 'NR==1{print "Smallest Partition:", $1, $2}; END{print "Largest Partition:", $1, $2}'
```

## Repair

### Rebalance the partitions: One way to remediate this incident is to rebalance the partitions in the Cassandra database. This involves redistributing the data across the nodes in a way that ensures even partition sizes. This can be done by running the nodetool repair command or by using a third-party tool such as Cassandra Reaper.
```shell


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


```