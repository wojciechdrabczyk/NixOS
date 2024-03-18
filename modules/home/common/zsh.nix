{
  config,
  pkgs,
  userConfig,
  ...
}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    syntaxHighlighting.enable = true;
    history = {
      size = 10000;
    };
    shellAliases = {
      sail = "[ -f sail ] && sh sail || sh vendor/bin/sail";
    };
    oh-my-zsh = {
      enable = true;
      plugins = ["git" "z"];
      theme = "robbyrussell";
    };
  };
  home.sessionPath = ["/home/${userConfig.userName}/.config/composer/vendor/bin"];
}
