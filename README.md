deploy_pki_certs
=========

A role to request and deploy a PKI cert from an AD Certificate Authority via the certsrv url.  This playbook generates a csr, requests a signed certificate, and installs the certificate to /etc/pki/tls/{certs|misc|private} folders for a RHEL variant hosts. You can also add a specify to only generate, but not upload, the certificates.  San variables can also be added to the CSR for proper cert generation.

Requirements
------------
```yaml
collections:
  - community.crypto
```

Role Variables
--------------

| Variable | Type |Required | Default | Note |
|:---|:---|:---|:---|:---:|
| cert_download_only | bool | no | - | Allows for only generating a cert, but will not upload to a remote host |
| email_address | string |yes | bigbob@cms4u2eat.com| |
| mystate | string | yes | Florida | |
| mylocation | string | yes | Tampa | |
| myorg | string | yes | CMS | |
| myou string | | yes | CMS4U2EAT | |
| mycountry|string |  yes | US | |
| pki_ca_host | string | yes | dc01.cms4u2eat.com | |
| pki_ca_url | string | yes | http://{{ pki_ca_host }}/certsrv | |
| pki_ca_req_url | string | yes | {{ pki_ca_url }}/certfnsh.asp | |
| pki_template_type | string | yes | CMS_Webserver | |
| pki_ca_referer | string | yes | {{ pki_ca_url }}/certrqxt.asp | |
| header_content | string | yes | -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'<br> -H 'Accept-Encoding: gzip, deflate'<br> -H 'Accept-Language: en-US,en;q=0.5'<br> -H 'Connection: keep-alive'<br> -H 'Host: {{ pki_ca_host }}'<br> -H 'User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; Trident/7.0; rv:11.0) like Gecko'<br> -H 'Content-Type: application/x-www-form-urlencoded'<br> -H 'Referer: https://{{ pki_ca_host }}/certsrv/certrqxt.asp'<br> | |
| data1_string | string | yes | Mode=newreq&CertRequest=| |
| data2_string | string | yes | &CertAttrib=CertificateTemplate:{{ pki_template_type }}&TargetStoreFlags=0&SaveCert=yes&ThumbPrint=| |
| san_names | list | no | - | A host will always be given its fqdn as a san name in addition to any others you provide |

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
    ad_password: !vault |
      $ANSIBLE_VAULT;1.2;AES256
      30613233633461343837653833666333643061636561303338373661313838333565653635353162
      3263363434623733343538653462613064333634333464660a663633623939393439316636633863
      61636237636537333938306331383339353265363239643939666639386530626330633337633833
      6664656334373166630a363736393262666465663432613932613036303963343263623137386239
      6330

# A host will always be given it's own fqdn as a SAN in addition
# to any san names you add to the san_names variable
# If you don't provide the san_name variable it will only get its 
# own fqdn as a SAN 
prod_servers:
  hosts:
    servera.example.com:
      san_names:
        - www.example.com
    serverb.example.com:
      san_names:
        - www.example.com
    haproxy.example.com:
      san_names:
        - servera.example.com
        - serverb.example.com
        - www.example.com
    serverc.example.com:
```

Example Playbook
----------------
```yaml
# Creates certs and pushes to RHEL variant hosts
- hosts: prod_servers
  gather_facts: True  
  roles:  
    - deploy_pki_cert  

# Creates certs but leaves them alone on the ansible controller in /tmp
# Should not be used in AAP/AWX.
- hosts: prod_servers
  gather_facts: True  
  vars:
    cert_download_only: true
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