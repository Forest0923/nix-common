{ config, lib, ... }:
let
  inherit (lib) mkAfter mkOption types;

  home_dir = config.home.homeDirectory;
  ghq_root = "${home_dir}/src";

  host_identities = config.nixCommon.git.hostIdentities;
  hosts = builtins.attrNames host_identities;

  mk_identity_file = host: {
    name = "git/identities/${host}.gitconfig";
    value = {
      text = ''
        [user]
          name = ${builtins.toJSON host_identities.${host}.name}
          email = ${builtins.toJSON host_identities.${host}.email}
      '';
    };
  };

  mk_include = host: {
    condition = "gitdir:${ghq_root}/${host}/";
    path = "${config.xdg.configHome}/git/identities/${host}.gitconfig";
  };
in
{
  options.nixCommon.git.hostIdentities = mkOption {
    type = types.attrsOf (
      types.submodule {
        options = {
          name = mkOption {
            type = types.str;
            description = "Git user.name for repositories under a specific host path.";
          };
          email = mkOption {
            type = types.str;
            description = "Git user.email for repositories under a specific host path.";
          };
        };
      }
    );
    default = { };
    example = {
      "github.com" = {
        name = "Your Name";
        email = "your.name@example.com";
      };
      "gitlab.com" = {
        name = "Your Name";
        email = "your.name+gitlab@example.com";
      };
    };
    description = ''
      Host-based git identities keyed by host directory under ghq root.
      For host `github.com`, this module generates:
      - includeIf condition: `gitdir:${ghq_root}/github.com/`
      - identity file: `${config.xdg.configHome}/git/identities/github.com.gitconfig`
    '';
  };

  config = {
    programs.git = {
      enable = true;
      includes = mkAfter (map mk_include hosts);

      settings = {
        user = {
          name = lib.mkDefault "";
          email = lib.mkDefault "";
        };
        alias = {
          d = "diff";
          dc = "diff --cached";
          graph = "log --graph --all --decorate";
          wt = "worktree";
        };
        init = {
          defaultbranch = "main";
        };
        ghq = {
          root = ghq_root;
        };
      };
    };

    xdg.configFile = builtins.listToAttrs (map mk_identity_file hosts);
  };
}
