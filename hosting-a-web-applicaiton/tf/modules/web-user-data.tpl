#!/bin/bash
# all commands run as root b/c this file is run via cloud-init as user-data in AWS

function ts() {
  date +"%D-%T"
}

echo "###############################################" | tee -a $LOG
echo "$(ts) - Bootstrap Log Start " | tee -a $LOG
echo "###############################################" | tee -a $LOG
echo "$(ts) - Installing Git & Ansible + Collections"
apt-get update
apt-get -y install jq git ansible awscli
ansible-galaxy collection install community.docker

echo "$(ts) - Getting Github credentials from SecretsManager" | tee -a $LOG
aws --region us-east-1 ssm get-parameters --with-decryption --names /github-key --query "Parameters[*].Value" --output text >>~/.ssh/github-runner-key
chmod 600 ~/.ssh/github-runner-key

cat <<EOF >>~/.gitconfig:with
[user]
    email = sre@sreproject.local
    name = kklein90
EOF

cat <<EOF >>~/.ssh/config
Host github.com
  Hostname github.com
  StrictHostKeyChecking accept-new
  IdentityFile ~/.ssh/github-runner-key
EOF

echo "$(ts) - Cloning git repositories for Ansible code." | tee -a $LOG
# the GITUSER & GITPASS variables here are escaped with $$ to prevent TF interference
git clone git@github.com:kklein90/sre-projects.git

echo "$(ts) - Running Ansible playbooks..."
cd sre-projects/hosting-a-web-applicaiton/ansible/linux/web && ansible-playbook sre-web-base.yml --extra-vars var_hostname=$'sre-web-srv-01'
