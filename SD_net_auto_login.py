#!/usr/bin/python3
# -*- coding:UTF-8 -*-
# -- 自动登录宿舍网 --
import requests
import json
def upload():
    #img_url ="https://10.134.42.103/cpauth/appindex?gw_id=C0%3AFF%3AD4%3A8E%3A09%3AA8&gw_address=10.135.15.4&gw_port=2060&mac=00%3AE1%3AB0%3A11%3A3E%3A97&authenticator=apAuthLocalUser&submit%5BapAuthLocalUserconnect%5D=%E7%99%BB%E9%99%86&apAuthLocalUser%5Busername%5D=F1235027&apAuthLocalUser%5Bpassword%5D=zxc12345"

    mheader={

        "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8",
        "Accept-Encoding": "gzip, deflate, br",
        "Accept-Language": "zh-CN,zh;q=0.8",
        "Cache-Control": "max-ag =0",
        "Connection": "keep-alive",
        "Content-Length": "264",
        "Content-Type": "application/x-www-form-urlencoded",
        "Cookie": "authpuppy=71g80pr2t5ion719a62m00qnu2",
        "Host": "10.134.42.103",
        "Origin": "https://10.134.42.103",
        "Referer": "https://10.134.42.103/cpauth/portal?gw_address=10.135.15.4&gw_port=2060&gw_id=C0:FF:D4:8E:73:AA&ssid=SmartDorm907&ip=10.135.15.44&mac=00:E1:B0:11:3E:97&url=http://chinared.xyz",
        "Upgrade-Insecure-Requests":"1",
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/56.0.2924.87 Safari/537.36",
    }

    mparam={
        "gw_id": "C0:FF:D4:8E:73:AA",
        "gw_address": "10.135.15.4",
        "gw_port": "2060",
        "mac": "00%3AE1%3AB0%3A11%3A3E%3A97",
        "authenticator": "apAuthLocalUser",
        "submit[apAuthLocalUserconnect]": "登陆",
        "apAuthLocalUser[username]": "F1235027",
        "apAuthLocalUser[password]": "zxc12345",
    }
    mdata={
        "apAuthLocalUser[username]": "F1235027",
        "apAuthLocalUser[password]": "zxc12345",
    }
    
    
    murl="https://10.134.42.103/wlcauth/login/?gw_address=10.135.15.4&gw_port=2060&gw_id=C0:FF:D4:8E:73:AA&ip=10.135.15.44&mac=00:E1:B0:11:3E:97&ssid=SmartDorm907&url=http://chinared.xyz"
    import urllib
    mparam = urllib.parse.urlencode(mparam).encode('utf-8')
    requests.packages.urllib3.disable_warnings()
    r = requests.post(url=murl, params=mparam, headers=mheader, data=mdata, verify=False)
    #dict = r.json()
    print(r.text)
    #print(dict['headers'])
    print("Finish")

upload()

