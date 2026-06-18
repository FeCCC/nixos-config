{
  config,
  lib,
  modulesPath,
  pkgs,
  ...
}:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./zfs.nix
    ./nfs.nix
  ];

  boot.initrd.availableKernelModules = [
    "ahci"
    "xhci_pci"
    "megaraid_sas"
    "usb_storage"
    "usbhid"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  swapDevices = [ { device = "/dev/zvol/rpool/swap"; } ];

  #显卡
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = false; # V100 不需要
    open = false; # V100 是 Volta，不支持 open driver
    nvidiaSettings = false;
    package = config.boot.kernelPackages.nvidiaPackages.legacy_580; # 580 是支持 V100 的最后一个版本
  };
  hardware.graphics.enable32Bit = true;
  hardware.nvidia-container-toolkit.enable = true;
  environment.systemPackages = [ pkgs.nvtopPackages.nvidia ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
