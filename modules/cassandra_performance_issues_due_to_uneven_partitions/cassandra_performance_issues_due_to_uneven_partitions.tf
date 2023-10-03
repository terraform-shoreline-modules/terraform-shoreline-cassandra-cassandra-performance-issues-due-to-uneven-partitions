resource "shoreline_notebook" "cassandra_performance_issues_due_to_uneven_partitions" {
  name       = "cassandra_performance_issues_due_to_uneven_partitions"
  data       = file("${path.module}/data/cassandra_performance_issues_due_to_uneven_partitions.json")
  depends_on = [shoreline_action.invoke_cassandra_repair]
}

resource "shoreline_file" "cassandra_repair" {
  name             = "cassandra_repair"
  input_file       = "${path.module}/data/cassandra_repair.sh"
  md5              = filemd5("${path.module}/data/cassandra_repair.sh")
  description      = "Rebalance the partitions: One way to remediate this incident is to rebalance the partitions in the Cassandra database. This involves redistributing the data across the nodes in a way that ensures even partition sizes. This can be done by running the nodetool repair command or by using a third-party tool such as Cassandra Reaper."
  destination_path = "/agent/scripts/cassandra_repair.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_cassandra_repair" {
  name        = "invoke_cassandra_repair"
  description = "Rebalance the partitions: One way to remediate this incident is to rebalance the partitions in the Cassandra database. This involves redistributing the data across the nodes in a way that ensures even partition sizes. This can be done by running the nodetool repair command or by using a third-party tool such as Cassandra Reaper."
  command     = "`chmod +x /agent/scripts/cassandra_repair.sh && /agent/scripts/cassandra_repair.sh`"
  params      = ["PATH_TO_NODETOOL_DIR","PATH_TO_CASSANDRA_DIR"]
  file_deps   = ["cassandra_repair"]
  enabled     = true
  depends_on  = [shoreline_file.cassandra_repair]
}

