{ lib, ... }:
{
  options.my_config.fabric.vps = lib.mkOption {
    type = lib.types.str;
    default = "47.243.180.98";
    description = "自建公网入口地址，组网与 frp 都指向它";
  };
}
