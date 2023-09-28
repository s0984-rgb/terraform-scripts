job "tetris" {
  datacenters = ["dc1"]
  group "games" {
    count = 1
    network {
      port "web" {
        to = 80
      }
    }
    task "tetris" {
      driver = "docker"
      config {
        image          = "bsord/tetris"
        ports          = ["web"]
        auth_soft_fail = true
      }
      resources {
        cpu    = 50
        memory = 256
      }
    }
  }
}