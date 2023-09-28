job "tf2" {
  datacenters = ["dc1"]
  group "server" {
    count = 1
    network {
      mode = "host"
      port "tf2" {
        static = 27015
      }
      port "tf2-tv" {
        static = 27016
      }
      port "tf2-client" {
        static = 27005
      }
    }
    task "run" {
      driver = "docker"
      env {
        SRCDS_TOKEN    = "6C4786CB6E116CC59B3D449E764C8EF0"
        SRCDS_STARTMAP = "ctf_2fort"
        SRCDS_PORT     = "27015"
        SRCDS_TV_PORT  = "27016"
      }
      config {
        image          = "cm2network/tf2"
        ports          = ["tf2", "tf2-tv", "tf2-client"]
        auth_soft_fail = true
      }
      resources {
        cpu    = 2000
        memory = 3800
      }
    }
  }
}