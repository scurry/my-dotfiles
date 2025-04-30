#!/bin/bash

# all the proxies to set, include both CASES.
proxies=( ALL_PROXY all_proxy http_proxy https_proxy HTTPS_PROXY HTTP_PROXY RSYNC_PROXY rsync_proxy ftp_proxy FTP_PROXY )

case "$1" in
 off)
    echo "Unsetting any proxy values."
    for pname in "${proxies[@]}";do
     unset $pname
    done
    echo "Ensure CNTLM is stopped"
    brew services stop cntlm
    echo "Turn off proxy network setting"
    sudo networksetup -setautoproxystate "Wi-Fi" off
    echo "Disabling proxy in global git config"
     git config --global --unset http.proxy
     git config --global --unset https.proxy
     set | grep -i 'proxy='
    ;;
 on)
    echo "Setting proxy for http(s), ftp and rsync"
    for pname in "${proxies[@]}";do
     export $pname=http://www-proxy.lmig.com:80
    done
    echo "Turn on proxy network setting"
    sudo networksetup -setautoproxyurl "Wi-Fi" http://www-proxy-pac.lmig.com/proxy.pac
    sudo networksetup -setautoproxystate "Wi-Fi" on
    echo "setting global git proxy"
    git config --global http.proxy http://www-proxy.lmig.com:80
    git config --global https.proxy http://www-proxy.lmig.com:80
    export no_proxy="*.local"
    set | grep -i 'proxy='
    ;;
 local)
    echo "Ensure CNTLM is started"
    brew services start cntlm
    echo "Specifying local port as proxy"
    for pname in "${proxies[@]}";do
     export $pname=http://127.0.0.1:3128
    done
    echo "Turn on proxy network setting"
    sudo networksetup -setautoproxyurl "Wi-Fi" http://www-proxy-pac.lmig.com/proxy.pac
    sudo networksetup -setautoproxystate "Wi-Fi" on
    echo "setting global git proxy"
    git config --global http.proxy http://127.0.0.1:3128
    git config --global https.proxy http://127.0.0.1:3128
    set | grep -i 'proxy='
    ;;
 fix)
    echo "Resetting CNTLM configuration, use your enterprise ID when prompted"
    cntlm -T /tmp/cntlmpass -IM https://index.docker.io/v1/repositories/sonatype/nexus/images
    rez=`grep 'PassNTLMv2' /tmp/cntlmpass`
    if [ -n "$rez" ];then
        echo "adding $rez to cntlm config"
        sed -Ei '' "s/PassNTLMv2.*/$rez/" /usr/local/etc/cntlm.conf
        echo "restarting cntlm"
        killall cntlm
        /usr/local/bin/cntlm
        echo "done, local proxy should use new password"
    else
        echo "cntlm failure"
        cat /tmp/cntlmpass
    fi
    ;;
*)
    echo "Usage: \`source $0 on|off\`"
    ;;
esac
