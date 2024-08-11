{ config, lib, pkgs, ... }:

let
  cfg = config.services.meow;
  hello_meow = pkgs.writeShellApplication {
    name = "hello_meow";
    runtimeInputs = [ pkgs.coreutils ];
    text = ''
      echo meow
    '';
  };
  bai_meow = pkgs.writeShellApplication {
    name = "bai_meow";
    runtimeInputs = [ pkgs.coreutils ];
    text = ''
      echo meow meow
    '';
  };
in
with lib;
{
  options = {
    services.meow = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = ''
          meow meow meow
        '';
      };

      user = mkOption {
        default = "root";
        type = with types; uniq str;
        description = ''
          Name of the user
        '';
      };
    };
  };
  config = mkIf cfg.enable {
    systemd.user.services.meow = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      description = "meow meow meow";
      serviceConfig = {
        Type = "forking";
        User = "${cfg.user}";
        ExecStart = "${hello_meow}/bin/hello_meow";
        ExecStop = "${bai_meow}/bin/bai_meow";
        TimeoutSec = 10;
      };
    };
    systemd.user.timers.meow = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = "0m";
        OnUnitActiveSec = "1m";
        Unit = "meow.service";
      };
    };
  };
}
