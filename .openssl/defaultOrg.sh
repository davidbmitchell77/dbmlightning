#!/bin/bash
ssldir=./.openssl
clientid=3MVG9LBJLApeX_PBe5D.GL.rVgr1zYTbEmTFhLxf2k1kBbzObpkkEUFR2G.RyvCajbQ_qKtDEwSnqjAZO87Jt
jwtkeyfile=server.key
username=davidbmitchell77@outlook.com.lightning
alias=dbmlightning-dev-ed.my.salesforce.com
url=https://login.salesforce.com
cd $ssldir
sf org:login:jwt --jwt-key-file $jwtkeyfile --client-id $clientid --username $username --alias $alias --instance-url $url --set-default-dev-hub --set-default
sf org list --all
cd ..
