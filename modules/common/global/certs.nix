{...}: {
 security = {
  rtkit.enable = true;
  pki.certificateFiles = [
    ./ca.crt
  ];
 };
}
