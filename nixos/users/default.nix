{
  config,
  lib,
  ...
}:
{
  imports = [
    ./root.nix
    ./miku.nix
  ];

  options.my_config.normalUsers = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    description = "Normal (human) users; per-user modules iterate this list.";
  };

  config = {
    users.mutableUsers = false;
    my_config.normalUsers = [ "miku" ];

    assertions = [
      {
        assertion = lib.all (user: lib.hasAttr user config.users.users) config.my_config.normalUsers;
        message = "my_config.normalUsers lists a user that is not defined.";
      }
      {
        assertion = lib.all (
          user:
          !(config.users.users.${user}.isNormalUser or false) || lib.elem user config.my_config.normalUsers
        ) (lib.attrNames config.users.users);
        message = "A normal user is missing from my_config.normalUsers.";
      }
    ];
  };
}
