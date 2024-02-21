#!/bin/bash
ver=$(cat /var/lib/jenkins/workspace/calcip/README | grep "Version:" | cut -d " " -f 2)
echo $ver
ver_ant=$(cat /var/lib/jenkins/workspace/calcip/README | grep "Version anterior:" | cut -d " " -f 3)
echo $ver_ant

ssh vagrant@produccio mkdir -p projectes/calcip/$ver
scp -r /var/lib/jenkins/workspace/calcip vagrant@produccio:~/projectes/calcip/$ver
if [[ -z $ver_ant ]]
then
    comprova=$(ssh vagrant@produccio ls /home/vagrant/projectes/calcip | grep $ver_ant)
    if [[ $comprova != "" ]]
    then
        ssh vagrant@produccio docker-compose -f /home/vagrant/projectes/calcip/$ver_ant/calcip/docker-compose.yml down
    fi
fi
ssh vagrant@produccio docker-compose -f /home/vagrant/projectes/calcip/$ver/calcip/docker-compose.yml up -d
exit 0
