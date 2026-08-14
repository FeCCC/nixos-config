{
  # hush fan controller — Dell iDRAC 风扇偏移控制（Web GUI :8086）

  system.activationScripts."hush-data-dir" = {
    text = ''
      DATA_DIR=/data/appdata/hush/data
      LOGS_DIR=/data/appdata/hush/logs
      if [ ! -d "$DATA_DIR" ]; then
        mkdir -p "$DATA_DIR"
        chown 1000:1000 "$DATA_DIR"
        chmod 750 "$DATA_DIR"
      fi
      if [ ! -d "$LOGS_DIR" ]; then
        mkdir -p "$LOGS_DIR"
        chown 1000:1000 "$LOGS_DIR"
        chmod 750 "$LOGS_DIR"
      fi
    '';
  };

  virtualisation.oci-containers = {
    backend = "docker";
    containers.hush = {
      image = "ghcr.io/natankeddem/hush:latest";
      autoStart = true;
      ports = [ "8086:8080" ];
      volumes = [
        "/data/appdata/hush/data:/app/data"
        "/data/appdata/hush/logs:/app/logs"
      ];
    };
  };

}
