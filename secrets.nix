let
  adminPublicKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKeb7OYEVYWXIuvyKrUeARMV1Eu7siUgmaIS89Rt9swd secrets@HopeHouseGateway.git"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIo0rqolIwrG9+2xM6nQSDmPkEAprLEstESby+KtwoDa super@super-systems"
  ];

  hostPublicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILanR35vd9pTMH7u6q9dr57p8/Twnh7ny5PEnTQEtqUN root@h2-gateway";
in
{
  # note: comment this before running `agenix -r`
  inherit adminPublicKeys;

  "secrets/root-passwd.age".publicKeys = adminPublicKeys ++ [ hostPublicKey ];
}
