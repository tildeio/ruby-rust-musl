#!/usr/bin/env bash

set -e -x

# Correctly checks if a command exists
cmd_exists () {
  if command -v $1 >/dev/null 2>&1; then
    return 0
  else
    return 1
  fi
}

# Resolve this issue at the start
if ! grep -q "ubuntu-xenial" /etc/hosts; then
  echo "127.0.1.1 ubuntu-xenial" | sudo tee -a /etc/hosts >/dev/null
fi

sudo apt-get update
sudo apt-get upgrade -y

if ! cmd_exists gdb; then
  sudo apt-get install gdb -y
fi

if ! cmd_exists rustup; then
  curl https://sh.rustup.rs -sSf | sh -s -- --default-toolchain nightly -y
  export PATH="$HOME/.cargo/bin:$PATH"
fi

rustup target add x86_64-unknown-linux-musl

if ! cmd_exists rvm; then
  curl -sSL https://get.rvm.io | bash -s
  source ~/.rvm/scripts/rvm
fi

rvm install 2.3.1
rvm use 2.3.1 --default
gem install bundler

# Do this last so we see the restart message
if [ ! -e "/usr/share/virtualbox/VBoxGuestAdditions.iso" ]; then
  sudo apt-get install build-essential module-assistant -y
  sudo m-a prepare
  # Do we need the build-essentials and module-assistant if we do this?
  sudo apt-get install virtualbox-guest-additions-iso -y
  sudo mkdir -p /media/iso
  sudo mount -o loop /usr/share/virtualbox/VBoxGuestAdditions.iso /media/iso
  sudo /media/iso/VBoxLinuxAdditions.run

  set +x
  echo "**************"
  echo "VBox Guest Additions installation requires a reboot. Please reload the box with \`vagrant reload\`."
  echo "**************"
  set -x
fi
