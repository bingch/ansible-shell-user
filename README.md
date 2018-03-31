Role Name
=========

Linux local user module with hosts and hosts.allow config

Requirements
------------

Depends on tcpwrapper role to handle user's hosts.allow config

Role Variables
--------------
 
 users_list: []                # users yml path list to be created
 
 default_shell: /sbin/nologin  # should really be bash, but I'm panaroid
 default_user_group: users
 default_pass: "!*!"           # can also load from file, see below
 default_user_groups: ['users']
 
 override_existing_user: false # don't touch existing user by default
 set_tcpwrapper: false         # set to true if need hosts.allow to restrict ssh
 set_uid: false
 
 users_delete_list: []         # users yml path list to be removed
 
 default_home_remove: false    # by default we don't remove user's home, but 
 default_home_mode: '0000'     # change remain user's home to other owner
 default_home_owner: 'root'    # and set different mode
 default_home_group: 'root'
 default_remove_force: false      # if set to true, force remove user  
 users_delete_path: 'user-delete/'# default remove user yml folder
 
Dependencies
------------

tcpwrapper

Example Playbook
------------

User config files should usually stay out of inventory folders as most of time
user want to keep using the same ssh key to access different hosts, and have 
separate config files each individual make managing them much easier.

A typical user joe's meta file, joe.yml will reference different sub-folders:
  
<pre>
.
├── keys          # holds user public keys
│   └── joe.pub
│
├── meta          # default user meta file folder, username should match
│   └── joe.yml   # match user's yml file name, <b>user_yml_path</b> default      
│
├── sudo          # special (e.g. sudo) set <b>user_yml_path<b/> to 'sudo/'
│   └── joe.yml   # in user's meta yml file
│
├── users_delete  # if we need to delete joe, move her here for clarity
│   └── joe.yml   # <b>users_delete_path</b> default
│
└── vault         # users encrypted passwd hash
    └── joe_top_secret
</pre>

meta/joe.yml without sudo priviledge
<pre>
---
username: joe
groups_to_create:            # extra goups other the default user group name                            
  - name: joetest            # same as username, which will be created by
    gid: 9876                # default
comment: "Joe John"
uid: 1234
usergroups: ['joetest']
workstations:                # user machine conf for hosts/hosts.allow
  - ip: '1.2.3.4'
    host: 'joe-john-workstation'
password_file: "vault/joe_top_secret" # can also use password for direct hash
sudo_user: false 
ssh_key_files: []
</pre>

sudo/joe.yml with sudo priviledge
<pre>
---
username: joe
comment: "Joe John sudo user"
uid: 1234
usergroups: ['wheel']
shell: /bin/bash
workstations:
  - ip: '1.2.3.4'
    host: 'joe-john-workstation'
password_file: "vault/joe_top_secret"
sudo_user_nopasswd: yes  # <b>Be careful, this setting allow user sudo</b>
                         # <b>without password! You are warned. </b>
ssh_key_files: 
  - 'keys/joe.pub'
</pre>

test-add.yml
<pre>
---

- name: shell user for all servers
  include_role:
    name: shell-user
  vars:
    set_uid: true
    set_tcpwrapper: true          # set hosts.allow
    users_list:
      - 'meta/bart.yml'
      - 'meta/mary.yml'
      - 'meta/12345.yml'
      - 'meta/sudo/joe.yml'

</pre>
test-delete.yml

<pre>
---
- name: Add local shell user
  remote_user: root
  hosts: 192.168.122.2

  tasks:
    - name: delete user but keep their content
      include_role:
        name: shell-user
      vars:
        default_home_remove: false
        default_remove_force: false
        users_delete_list:
          - 'users_delete/12345.yml'
          - 'users_delete/bart.yml'

    - name: delete user with cleanup
      include_role:
        name: shell-user
      vars:
        default_home_remove: true
        default_remove_force: true
        users_delete_list:
          - 'users_delete/joe.yml'
          - 'users_delete/mary.yml'
</pre>

License
-------

GPL

Author Information
------------------

bing
