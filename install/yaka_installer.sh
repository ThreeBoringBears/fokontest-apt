#!/usr/bin/env bash

###############################################################################
#
#  Script Name	: install_nfs.sh
#
#  Description	:
#  Args		:
#
#  Version	:
#  Author	: Antony Turpin
#
###############################################################################

################################## Variables ##################################
IP_RANGE=$(dig +short haproxy01 | sed s/".[0-9]*$"/.0/g)

################################## Functions ##################################
function display_info() {
  echo -e "\033[44;37m[INFO]\e[0m\033[07;36m - $1\e[0m"
}

function prepare_directories() {
  display_info "XX. - Prepare Directories"
  mkdir -p /var/www/html
  chmod -R 655 /var/www/html
}

function update_system() {
  display_info "XX. NFS -- Installation"
  export DEBIAN_FRONTEND=noninteractive
  apt-get update && apt upgrade -y
  apt-get install -y apache2
}

function configure_ssh() {
  display_info "XX. NFS -- Installation"
  sed -i 's/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/g' /etc/ssh/sshd_config
  systemctl restart sshd
}
function install_repo () {
  display_info "XX. Apache2 -- Installation"
  ## Add repo
}
function docker_install() {
  display_info "XX. Docker -- Installation"
  ## Add docker install

}
function user_configuration() {
  display_info "XX. Users -- Initialisation"
  ## Add adduser + groups
}

##################################   Main    ##################################
prepare_directories
update_system
configure_ssh
install_repo
docker_install
user_configuration
