# emoji_service

This playbook deploys Flask service for having some fun with emoji:
1) Install python3, python3-pip and flask packages;
2) Copy app config and service config files to target machine (directiories creation included);
3) Run application as service and make sure it will start after reboot aftomatically;
4) Make your target machine a little bit more secure: 
    - disable root login;
    - close connections to all ports except 22, 80 and 443;
    - disable UsePAM;
    - enable Pubkey authentication (it is actually enable by default, but you can never be too self-confident).

## after deployment
```
You can send POST or GET request with name of my favorite emoji and receive strange string back.
For more detailed instruction look at http://yourserveraddress:80/ after successfull deploy.
Server will be availiable not only on target machine, but also from other computers in your local network.
```

## Prerequisites:

For target machine:
```
- enable root ssh login:
    1) Open /etc/ssh/sshd_config and change the following line (you also need to uncomment it):
        FROM: PermitRootLogin prohibit-password
        TO: PermitRootLogin yes
    2) Restart sshd service: /etc/init.d/ssh restart.
```

For host machine: 
```
- install ansible (apt install ansible);
- create ssh-key (ssh-keygen);
- copy ssh-key to target machine (ssh-copy-id -i ~/.ssh/id_rsa root@hostip).
- don't forget to clone the repository and set your target server address in /inventory/hosts.yml
```

# Deploying the app
Run the deploy playbook
```
 ansible-playbook emoji_service.yml
```