deploy_pki_certs
=========

A role to request and deploy a PKI cert from an AD Certificate Authority via the certsrv url.  This playbook generates a csr, requests a signed certificate, and installs the certificate to /etc/pki/tls/{certs|misc|private} folders for a Red Hat host. You can also add a specify to only generate, but not upload, the certificates.  San variables can also be added to the CSR for proper cert generation.

Requirements
------------
```yaml
collections:
  - community.crypto
```

Role Variables
--------------

| Variable | Required | Default | Note |
|:---|:---|:---|:---:|
| cert_download_only | no | - | Allows for only generating a cert, but will not upload to a remote host |
| email_address | yes | bigbob@cms4u2eat.com| |
| mystate | yes | Florida | |
| mylocation | yes | Tampa | |
| myorg | yes | CMS | |
| myou | yes | CMS4U2EAT | |
| mycountry| yes | US | |
| pki_ca_host | yes | dc01.cms4u2eat.com | |
| pki_ca_url | yes | http://{{ pki_ca_host }}/certsrv | |
| pki_ca_req_url | yes | {{ pki_ca_url }}/certfnsh.asp | |
| pki_template_type | yes | CMS_Webserver | |
| pki_ca_referer | yes | {{ pki_ca_url }}/certrqxt.asp | |
| header_content | yes | -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'<br> -H 'Accept-Encoding: gzip, deflate'<br> -H 'Accept-Language: en-US,en;q=0.5'<br> -H 'Connection: keep-alive'<br> -H 'Host: {{ pki_ca_host }}'<br> -H 'User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; Trident/7.0; rv:11.0) like Gecko'<br> -H 'Content-Type: application/x-www-form-urlencoded'<br> -H 'Referer: https://{{ pki_ca_host }}/certsrv/certrqxt.asp'<br> | |
| data1_string | yes | Mode=newreq&CertRequest=| |
| data2_string | yes | &CertAttrib=CertificateTemplate:{{ pki_template_type }}&TargetStoreFlags=0&SaveCert=yes&ThumbPrint=| |


Dependencies
------------

None

Example Inventory 
----------------
```yaml
---
all:
  vars:
    ad_username: bigbob
    ad_password: mysecretpass

prod_servers:
  hosts:
    servera.example.com:
      san_names:
        - onefish.example.com
        - twofish.example.com
        - www.example.com
    serverb.example.com:
      san_names:
        - redfish.example.com
        - bluefish.example.com
        - www.example.com
    haproxy.example.com:
      san_names:
        - servera.example.com
        - serverb.example.com
        - www.example.com
```

Example Playbook
----------------
```yaml
- hosts: prod_servers
  gather_facts: True  
  roles:  
    - deploy_pki_cert  
```

License
-------
MIT

Author Information
------------------

Randy Romero  
binbashroot@gmail.com