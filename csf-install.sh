#!/bin/bash

system_update()
{
 yum makecache
 yum update -y
}

install_dependencies()
{
  yum install wget perl-libwww-perl.noarch perl-Time-HiRes -y
}

download_install_csf()
{
  wget https://download.configserver.com/csf.tgz -P /usr/src/
  tar -xzf /usr/src/csf.tgz --directory /usr/src/
  sh /usr/src/csf/install.sh
}

disable_firewalld()
{
  systemctl stop firewalld
  systemctl disable firewalld
}

disable_csf_testing()
{
  sed -i 's/TESTING = "1"/TESTING = "0"/g' /etc/csf/csf.conf
}

enable_csf()
{
  systemctl start csf
  systemctl enable lfd
  systemctl start lfd
  systemctl enable csf
}

check_if_installed()
{
  CSF_DIR="/usr/sbin/csf"
  if [[ -e $CSF_DIR ]]; then
    echo "CSF is installed!"
  else
    echo "Something went wrong!"
  fi

}

main()
{
  system_update
  install_dependencies
  download_install_csf
  disable_firewalld
  disable_csf_testing
  enable_csf
  check_if_installed
}
main
