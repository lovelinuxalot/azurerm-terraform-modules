locals {
  jira_clusters = [
    {
      hostname  = "jmp-dev01.allianz.net"
      instances = 2
    }
  ]
}

output "out" {
  value = local.jira_clusters[0].hostname
}