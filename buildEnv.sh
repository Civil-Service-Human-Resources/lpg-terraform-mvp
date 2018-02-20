#!/bin/bash

#requirements
# - ansible
# - terraform
# - gnu-sed

echo -n "Enter name of new environemnt : "
read newEnv
echo -n "Enter Ansible vault password : "
read vaultpass
echo -n "Enter Azure user : "
read azuser
echo -n "Enter Azure password : "
read -s azpass

echo " ----- Creating new environment  ${newEnv} ! -----"

function error {
    rm -rf /tmp/${newEnv}
    exit 2
}

#azure login
az login -u ${azuser} -p ${azpass} || exit 2

#create key pair
ssh-keygen -t rsa -N "" -f ~/.ssh/${newEnv}.key

echo "----- Start Terraform-ing -----"
#clone repository
mkdir /tmp/${newEnv}
cd /tmp/${newEnv}
git clone https://github.com/Civil-Service-Human-Resources/lpg-terraform-mvp.git
cd lpg-terraform-mvp
#add public key to variables.tf
newPub=`cat ~/.ssh/${newEnv}.key.pub` || error
sed -i -e "/newkey/a \    \"${newEnv}\" = \"${newPub}\"" variables.tf
#decrypt files
echo ${vaultpass} > vault.yml
ansible-vault decrypt azure-state.tf --vault-password-file=vault.yml
ansible-vault decrypt azure-key.tf --vault-password-file=vault.yml
#run terraform
terraform init || error
terraform workspace new ${newEnv} || error
terraform workspace select ${newEnv}
terraform apply -auto-approve || error
#push key
git commit -am "adding ${newEnv}.key.pub" variables.tf
git push

echo "----- Start Ansible-ing -----"
#clone repository.
cd /tmp/${newEnv}
git clone https://github.com/Civil-Service-Human-Resources/lpg-ansible-mvp.git
cd lpg-ansible-mvp
#copy private key
cp ~/.ssh/${newEnv}.key mvp_${newEnv}
#create environment files
cp -r environments/test environments/${newEnv}
sed -i -e s/test/${newEnv}/ environments/${newEnv}/group_vars/all/env
#add vault password file
echo ${vaultpass} > vault.yml
#run ansible
ansible-playbook site.yml -i environments/${newEnv} -t
#push environment directory
git commit -am "adding ${newEnv}" .
git push

rm -rf /tmp/${newEnv}

echo "

 ---------- Add ~/.ssh/${newEnv}.key and ~/.ssh/${newEnv}.key.pub to last pass !!!!! ----------

 "