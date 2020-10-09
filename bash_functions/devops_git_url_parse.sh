#!/bin/bash

devops_git_url_parse () {
    protocol="${1:0:4}"
    if [ "${protocol}" != 'git@' ]; then
        protocol="$(echo ${1} | grep :// | sed -e's,^\(.*://\).*,\1,g')"
        url=$(echo ${1} | sed -e s,$protocol,,g)
        protocol="$(echo $protocol | cut -d: -f1)"
        user="$(echo $url | grep @ | cut -d@ -f1)"
        hostport=$(echo $url | sed -e s,$user@,,g | cut -d/ -f1)
        host="$(echo $hostport | sed -e 's,:.*,,g')"
        port="$(echo $hostport | sed -e 's,^.*:,:,g' -e 's,.*:\([0-9]*\).*,\1,g' -e 's,[^0-9],,g')"
        path="$(echo $url | grep / | cut -d/ -f2-)"
    else
        protocol="$(echo $1 | cut -d@ -f1)"
        url="$(echo $1 | cut -d@ -f2)"
        host="$(echo $url | cut -d: -f1)"
        path="$(echo $url | cut -d: -f2)"
        user=""
        port=""
        url="$(echo $url | sed -e 's,:,/,g')"
    fi
    name=`basename ${path}`
    name="${name%.*}"
    dirshort=`dirname ${path}`
    dirlong="${host}/${dirshort}"
    url="${dirlong}/${name}"
    case "${2}" in
        protocol)
        echo -n "${protocol}"
        ;;
        url)
        echo -n "${url}"
        ;;
        user)
        echo -n "${user}"
        ;;
        host)
        echo -n "${host}"
        ;;
        port)
        echo -n "${port}"
        ;;
        path)
        echo -n "${path}"
        ;;
        name)
        echo -n "${name}"
        ;;
        dirshort)
        echo -n "${dirshort}"
        ;;
        dirlong)
        echo -n "${dirlong}"
        ;;
        *)
    echo -n "
    protocol=$protocol
    user=$user
    host=$host
    port=$port
    path=$path
    url=$url
    name=$name
    dirshort=$dirshort
    dirlong=$dirlong
    "
    esac


}    
    