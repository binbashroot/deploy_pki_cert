deploy_pki_certs
=========

A role to deploy a pki certs for the host.  This playbook generates a csr, requests a signed certificate, and installs the 
certificate to /etc/pki/tls{certs|misc|private} folders.


Requirements
------------

Your inventory file must include a pki_san variable if there is a SAN name that is being used for the host.  
The SAN name should be a "short" san and not a fqdn.  

For example:  
[foo]  
foo.example.com pki_san=grafana

Role Variables
--------------

See the defaults/[main.yml](./defaults/main.yml)

Dependencies
------------

None

Example Playbook
----------------

- hosts: foo  
  gather_facts: True  
  vars_prompt:  
      - name: ad_user  
        prompt: "What is your AD login?"  
        private: no  
      - name: ad_pass  
        prompt: "What is your AD password?"  
        private: yes  
  roles:  
    - deploy_pki_cert  


License
-------


Author Information
------------------
