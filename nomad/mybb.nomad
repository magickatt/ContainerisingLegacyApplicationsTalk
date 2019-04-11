job "mybb" {
  datacenters = ["dc1"]

  group "mybb" {
    task "apache" {
      driver = "docker"

      template {
        source        = "/vagrant/configuration/settings.php"
        destination   = "local/config/mybb/settings.php"
        change_mode   = "signal" # https://httpd.apache.org/docs/2.4/stopping.html#graceful
        change_signal = "SIGUSR1"
      }

      template {
        source        = "/vagrant/configuration/config.php"
        destination   = "local/config/mybb/config.php"
        change_mode   = "signal"
        change_signal = "SIGUSR1"
      }

      config {
        image = "magickatt/mybb:2_noconfig"
        auth {
          username = "magickatt"
          password = "2f2pUMkbQZxpmz"
        }
      }

      resources {
        network {
          mbits = 10
          port "http" {
            static = "80"
          }
        }
      }
    }
  }
}
