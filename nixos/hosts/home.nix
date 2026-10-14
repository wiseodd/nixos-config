{ ... }: {
  boot.initrd.luks.devices."luks-bcf1c770-4fc1-4c9b-8fde-4cd7b9c6ccba".device =
    "/dev/disk/by-uuid/bcf1c770-4fc1-4c9b-8fde-4cd7b9c6ccba";
}
