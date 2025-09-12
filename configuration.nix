{
  pkgs,
  portfolio,
  ...
}: {
  imports = [];

  system.stateVersion = "25.05";

  services.caddy = {
    enable = true;
    # Serve the packaged `portfolio` derivation on port 80.
    virtualHosts = {
      ":80" = {
        # Use an extra Caddyfile snippet: set the root and enable file_server.
        extraConfig = ''
          root * ${portfolio}
          file_server
        '';
      };
    };
  };

  # Allow incoming HTTP on the guest so the QEMU host->guest forward works
  networking.firewall.allowedTCPPorts = [80];
}
