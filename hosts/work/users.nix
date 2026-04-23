let
  vars = import ./options.nix;
in
{
  users.users.${vars.userName} = {
    name = vars.userName;
    home = "/Users/${vars.userName}";
  };
}
