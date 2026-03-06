{
  inputs,
  outputs,
  ...
}: {
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "yes";
    };
  };

  users.users = {
    root = {
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC0Fzsq8CZ19p+CQKZkeCCC8mkiaKxAD/hnMSibIDk/RTZR0DCyxzzoZaqUSZ0RXpw+r+aHflplzT9fZIWZzCD3VxyJHm8t1iuZery73AnXxyG1Yuhk5/gfNqgPmoL0F0MYlsndTUjFH0isk8edWZxwM5soZD6RzYZj4cIlPJk4B6mtKs5ef80KzRgqdOFPLck0QXserFmUV+2NZJpCqbgzJlFcd56kSKkHsK8Vv29ktyGZHtXTMyJEvK769vxh9lHJt8gJ5P6JAXHFnBUaBXDBNB9QTfpzOzFwonUaLqqcJlexGvKLzuuKHF5kAzg8E0n4kFBNJvJvKr5MzxXsG+qP tmoss@tmoss-desktop-nixos"
      ];
    };
  };
}
