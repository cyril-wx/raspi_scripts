# -*- coding:utf-8 -*-
import requests
import time
import sys
from lxml import etree
reload(sys)
sys.setdefaultencoding('utf8')
#####################################
# 一键创建FRP隧道或删除FRP隧道
####################################


session = requests.session()
# 手动获取csrf， cookie
cookie = {
        "acw_tc": "2f5bc38c15936077807328920e79c6f9971f3cfd31ff14931afdc842de",
        "PHPSESSID": "tjhbk084t44o4im7sgoppdk544",
        "_ga": "GA1.2.876813571.1587480806",
        "_gid": "GA1.2.1249088767.1593607783",
        "_gat_gtag_UA_156685489_1": "1",
}
node = "21"  # 日本东京
#node = "37"  # 新加坡CN2-2
#node = "24"  # 新加坡CN2
csrf = "e189d8eeb1ca224b45f6aabbc1ae38ce" # 无需修改

def createProxy(node="12", proxy_name="", proxy_type="http", local_ip="127.0.0.1", local_port="80", remote_port="", domain="", cookie={}):
    data = {
        "node": node,
        "proxy_name": proxy_name,
        "proxy_type": proxy_type,
        "local_ip": local_ip,
        "local_port": local_port,
        "remote_port": remote_port,
        "domain": domain,
        "use_encryption": "false",
        "use_compression": "true",
        "locations": "",
        "host_header_rewrite": "",
        "header_X_From_Where": "",
        "sk": "",
    }

    headers = {
        "authority": "www.natfrp.com",
        "method": "POST",
        "path": "/?page=panel&module=addproxy&action=addproxy&csrf={}".format(csrf),
        "scheme": "https",
        "accept": "*/*",
        "accept-encoding": "gzip, deflate, br",
        "accept-language": "zh-CN,zh;q=0.9,en;q=0.8",
        "content-length": "215",
        "content-type": "application/x-www-form-urlencoded; charset=UTF-8",
        "cookie": "acw_tc={}; PHPSESSID={}; _ga={}; _gid={}; _gat_gtag_UA_156685489_1={}".format(
            cookie["acw_tc"],
            cookie["PHPSESSID"],
            cookie["_ga"],
            cookie["_gid"],
            cookie["_gat_gtag_UA_156685489_1"],),
        "dnt": "1",
        "origin": "https://www.natfrp.com",
        "referer": "https://www.natfrp.com/?page=panel&module=addproxy",
        "sec-fetch-mode": "cors",
        "sec-fetch-site": "same-origin",
        "user-agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.120 Safari/537.36",
        "x-requested-with": "XMLHttpRequest",
    }


    url = "https://www.natfrp.com{}".format(headers["path"])
    res = session.post(url, cookies=cookie, headers=headers, data=data)
    print ("=================[{}]==================".format(proxy_name))
    print ("Response:{}".format(res.text.encode()))
    time.sleep(1)
    if res.text.strip() == u"隧道创建成功":
        return True
    else:
        return False


def createProxies():
    """
    # 批量创建隧道
    :return:
    """
    # 自动批量创建FRP节点
    result = [
        createProxy(node=node, proxy_name="Gitlab", proxy_type="http", local_ip="127.0.0.1", local_port="8082",
                        remote_port="", domain="gitlab.chinared.xyz", cookie=cookie),
        createProxy(node=node, proxy_name="Code", proxy_type="http", local_ip="127.0.0.1", local_port="8100",
                        remote_port="", domain="code.chinared.xyz", cookie=cookie),
        createProxy(node=node, proxy_name="Liaoliao", proxy_type="http", local_ip="127.0.0.1", local_port="80",
                        remote_port="", domain="ll.chinared.xyz", cookie=cookie),
        createProxy(node=node, proxy_name="SQLAdmin", proxy_type="http", local_ip="127.0.0.1", local_port="888",
                        remote_port="", domain="sqladmin.chinared.xyz", cookie=cookie),
        createProxy(node=node, proxy_name="H5ai", proxy_type="http", local_ip="127.0.0.1", local_port="80",
                        remote_port="", domain="h5ai.chinared.xyz", cookie=cookie),
        createProxy(node=node, proxy_name="Baota", proxy_type="http", local_ip="127.0.0.1", local_port="8899",
                        remote_port="", domain="pi.chinared.xyz", cookie=cookie),
        createProxy(node=node, proxy_name="SQL", proxy_type="tcp", local_ip="127.0.0.1", local_port="3306",
                        remote_port="11667", domain="", cookie=cookie),
        #createProxy(node=node, proxy_name="MySSH", proxy_type="tcp", local_ip="127.0.0.1", local_port="12580",
        #            remote_port="12581", domain="", cookie=cookie),
    ]
    print ("Error count: {}F/{}".format(len([i for i in result if i == False]), len(result)))


def getProxyIds():
    """
    # 获取当前所有Proxies Id
    :return: [list]
    """
    url="https://www.natfrp.com/?page=panel&module=proxies"
    headers = {
        "authority": "www.natfrp.com",
        "method": "GET",
        "path": "/?page=panel&module=addproxy&action=addproxy&csrf={}".format(csrf),
        "scheme": "https",
        "accept": "*/*",
        "accept-encoding": "gzip, deflate, br",
        "accept-language": "zh-Hans-CN, zh-Hans; q=0.5",
        "content-length": "215",
        "content-type": "application/x-www-form-urlencoded; charset=UTF-8",
        "cookie": "acw_tc={}; PHPSESSID={}; _ga={}; _gid={}; _gat_gtag_UA_156685489_1={}".format(cookie["acw_tc"],
                                                                                                 cookie["PHPSESSID"],
                                                                                                 cookie["_ga"],
                                                                                                 cookie["_gid"],
                                                                                                 cookie["_gat_gtag_UA_156685489_1"], ),
        "dnt": "1",
        "origin": "https://www.natfrp.com",
        "referer": "https://www.natfrp.com/?page=panel&module=proxies",
        "sec-fetch-mode": "cors",
        "sec-fetch-site": "same-origin",
        "user-agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.120 Safari/537.36",
        "x-requested-with": "XMLHttpRequest",
    }
    data = {
        'module':'proxies',
        'page':'panel'
    }
    res = requests.get(url, cookies=cookie, headers=headers, data=data)

    html = etree.HTML(res.text)  # 初始化生成一个XPath解析对象
    #result = etree.tostring(html, encoding='utf-8')  # 解析对象输出代码
    tbody = html.xpath("//tbody/tr/td/text()")   # 解析tbody-tr-td下元素，使用text()获取值

    proxy_ids_dict = {}
    pre_id = "" #记录循环中的前一个proxy_id
    for i in range(len(tbody)):
        if  i%6 == 0:
            pre_id = tbody[i]       # 获取proxy id
        elif i%6 == 1:
            proxy_ids_dict.setdefault(pre_id, tbody[i])  # 获取proxy name，并存入 proxy_id:proxy_name
    print (proxy_ids_dict)
    return proxy_ids_dict


def deleteProxiesById(id_names={}):
    url = "https://www.natfrp.com/?page=panel&module=proxies"
    headers = {
        "authority": "www.natfrp.com",
        "method": "GET",
        "path": "/?page=panel&module=proxies",
        "scheme": "https",
        "accept": "*/*",
        "accept-encoding": "gzip, deflate, br",
        "accept-language": "zh-Hans-CN, zh-Hans; q=0.5",
        "content-length": "215",
        "content-type": "application/x-www-form-urlencoded; charset=UTF-8",
        "cookie": "acw_tc={}; PHPSESSID={}; _ga={}; _gid={}; _gat_gtag_UA_156685489_1={}".format(cookie["acw_tc"],
                                                                                                 cookie["PHPSESSID"],
                                                                                                 cookie["_ga"],
                                                                                                 cookie["_gid"], cookie[
                                                                                                     "_gat_gtag_UA_156685489_1"], ),
        "dnt": "1",
        "origin": "https://www.natfrp.com",
        "referer": "https://www.natfrp.com/?page=panel&module=proxies",
        "sec-fetch-mode": "cors",
        "sec-fetch-site": "same-origin",
        "user-agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.120 Safari/537.36",
        "x-requested-with": "XMLHttpRequest",
    }

    for i in id_names:
        data = {
            'csrf': csrf,
            'delete': i,
            'module': "proxies",
            'panel': "panel"
        }
        _url = url + "&delete={}&csrf={}".format(i, csrf)
        headers["path"] = headers["path"] + "&delete={}&csrf={}".format(i, csrf)
        res = requests.get(_url, cookies=cookie, headers=headers, data=data)
        print ("删除隧道：{}. Response: {}".format(id_names[i], res.text))
        time.sleep(1)


if __name__ == "__main__":
    #createProxies()
    pIds = getProxyIds()
    deleteProxiesById(pIds)
    pass


