{...}: {
  virtualisation.vmVariant = {
    # following configuration is added only when building VM with build-vm
    virtualisation = {
      memorySize = 2048; # Use 2048MiB memory.
      cores = 4;
      graphics = false;
      forwardPorts = [
        {
          from = "host";
          host.port = 2222;
          guest.port = 80;
        }
      ];
    };
  };

  # user
  services.getty.autologinUser = "root";
  users.users.root.initialPassword = "root";
}
