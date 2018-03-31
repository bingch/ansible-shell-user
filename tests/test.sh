#!/bin/bash

echo "generating bart's ssh for testing..."
rm bart
ssh-keygen -f bart -N "" && mv bart.pub ./keys && cp ./keys/bart.pub ./keys/joe.pub 

#ansible-playbook -i inventory test-add.yml
#exit
ansible-playbook -i inventory test.yml

echo "remove bart's keys..."
rm -f bart bart.pub
rm -f ./keys/*.pub
