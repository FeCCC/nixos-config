{
  config,
  lib,
  ...
}:
{
  options.my_config.fail2ban.enable = lib.mkEnableOption "fail2ban（sshd jail）";

  config = lib.mkIf config.my_config.fail2ban.enable {
    services.fail2ban = {
      enable = true;
      jails.sshd.settings = {
        maxretry = 5;
        bantime = "1h";
      };
    };

    # 关掉 sshd 自带的短时惩罚，否则它先断连、fail2ban 数不到失败次数
    services.openssh.settings.PerSourcePenalties = lib.mkIf config.services.openssh.enable "no";
  };
}
