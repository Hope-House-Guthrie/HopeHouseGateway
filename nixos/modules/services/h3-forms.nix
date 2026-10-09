{ config, secretsPath, ... }:
{
  age.secrets.h3_dev-azure-service-bus = {
    file = "${secretsPath}/h3/dev-azure-service-bus.age";
    mode = "0400";
    owner = config.services.h3-forms.dev.user;
    group = config.services.h3-forms.dev.group;
  };

  services.h3-forms.dev = {
    enable = true;
    azureServiceBusFile = config.age.secrets.h3_dev-azure-service-bus.path;
  };
}