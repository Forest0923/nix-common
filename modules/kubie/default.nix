{ pkgs, ... }:
{
  home.packages = with pkgs; [
    kubie
  ];

  home.file.".kube/kubie.yaml".text = ''
    configs:
        include:
            - ~/.kube/config
            - ~/.kube/*.yml
            - ~/.kube/*.yaml
            - ~/.kube/configs/*.yml
            - ~/.kube/configs/*.yaml
            - ~/.kube/kubie/*.yml
            - ~/.kube/kubie/*.yaml
        exclude:
            - ~/.kube/kubie.yaml
    prompt:
        disable: true
    behavior:
        validate_namespaces: false
  '';
}
