#!/bin/bash


echo "generating bart's ssh for testing..."
rm bart
ssh-keygen -f bart -N "" && mv bart.pub ./keys && cp ./keys/bart.pub ./keys/joe.pub 

echo "test run..."
ansible-playbook -i inventory test-run.yml -C
if [ $? -ne 0 ]
then
  echo "test run failed"
  exit 1
fi

echo "real run..."
ansible-playbook -i inventory test.yml
if [ $? -ne 0 ]
then
  echo "real run failed"
  exit 1
fi

echo "remove bart's keys..."
rm -f bart bart.pub
rm -f ./keys/*.pub
