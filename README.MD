This is test repo for terraform&ansible provisioning training

1. Init stack with terraform: 
 - ```terraform plan```
 - ```terraform apply```
2. Run ansible-playbook
 - Fill inventory file with IP's from terraform output
 - ```ansible-playbook -i inventory playbook.yml```
