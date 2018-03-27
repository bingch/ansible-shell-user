Role Name
=========

User module with hosts and hosts.allow config, inspired by ansible-users

Requirements
------------

Depends on tcpwrapper role to handle user's hosts.allow config

Role Variables
--------------

A description of the settable variables for this role should go here, including any variables that are in defaults/main.yml, vars/main.yml, and any variables that can/should be set via parameters to the role. Any variables that are read from other roles and/or the global scope (ie. hostvars, group vars, etc.) should be mentioned here as well.

Dependencies
------------

tcpwrapper

Example Playbook
----------------

test.yml:

---
- name: Add local shell user
  remote_user: root
  hosts: localhost

  tasks:
    # real user
    - name: shell user for all servers
      include_role:
        name: shell-user
      vars:
        user_meta: "{{shelluserloop}}"
      with_items:
        - 'joe.yml'
      loop_control:
        loop_var: shelluserloop


joe.yml:

---
username: joe
comment: "Joe John"
uid: 1234
group: users
usergroups: ['wheel']
workstations:
  - ip: '1.2.3.4'
    host: 'joe-john-workstation'
password: "!!"
sudo_user: false
ssh_key_files: []

License
-------

GPL

Author Information
------------------

bingch
https://github.com/bingch
