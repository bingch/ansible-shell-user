#!/bin/bash


echo "generating bart's ssh for testing..."
rm bart
ssh-keygen -f bart -N "" && mv bart.pub ./keys && cp ./keys/bart.pub ./keys/joe.pub 

echo "test run..."
time ansible-playbook -i inventory test-run.yml -C
echo "real run..."
time ansible-playbook -i inventory test.yml

echo "remove bart's keys..."
rm -f bart bart.pub
rm -f ./keys/*.pub
