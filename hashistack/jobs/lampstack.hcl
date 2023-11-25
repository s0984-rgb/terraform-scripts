job "lampstack" {
  datacenters = ["dc1"]

  group "mysql" {
    count = 1
    network {
      mode = "bridge"
    }
    service {
      name = "mysql"
      port = "3306"

      connect {
        sidecar_service {}
      }
    }
    task "run" {
      driver = "docker"
      env {
        MYSQL_DATABASE      = "test"
        MYSQL_USER          = "test"
        MYSQL_PASSWORD      = "test"
        MYSQL_ROOT_PASSWORD = "root"
      }
      config {
        image          = "mysql:5.7"
        auth_soft_fail = true
      }
      resources {
        cpu    = 100
        memory = 1024
      }
    }
  }

  group "phpmyadmin" {
    count = 1
    network {
      mode = "bridge"

      port "pma" {
        static = 8080
        to     = 80
      }
    }

    service {
      name = "phpmyadmin"
      port = "pma"

      connect {
        sidecar_service {
          proxy {
            upstreams {
              destination_name = "mysql"
              local_bind_port = 3306
            }
          }
        }
      }
    }

    task "run" {
      driver = "docker"
      env {
        PMA_HOST = "127.0.0.1"
        PMA_PORT = "3306"
      }
      config {
        image          = "phpmyadmin"
        auth_soft_fail = true
      }
      resources {
        cpu    = 100
        memory = 512
      }
    }
  }
}