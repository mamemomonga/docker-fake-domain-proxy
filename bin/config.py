#!/usr/bin/env python
# -*- coding: utf-8 -*-
# vim:fileencoding=utf-8

def _startup():
    from site import addsitedir
    from os.path import dirname, realpath, abspath
    basedir = abspath(dirname( realpath(__file__)) + '/..' )
    return basedir
basedir = _startup()

def _logger():
    from logging import getLogger, StreamHandler, Formatter, DEBUG
    import sys
    logger = getLogger(__name__)
    handler = StreamHandler(sys.stderr)
    handler.setFormatter( Formatter(fmt='[%(asctime)-15s][%(levelname)-8s] %(message)s'))
    handler.setLevel(DEBUG)
    logger.setLevel(DEBUG)
    logger.addHandler(handler)
    logger.propagate = False
    return logger
logger = _logger()

# YAMLロード
def load_yaml(fn):
    import sys, yaml
    from os.path import exists,basename

    logger.info("Load: %s" % fn)
    if not exists(fn):
        logger.critical("%s がありません" % fn)
        sys.exit(2)

    data=None
    with open(fn,'r') as f:
        data=yaml.load(f)
        f.close()
    return data

# ファイル書き込み
def write_file(fn,data):
    logger.info("Write: %s" % fn)
    with open(fn,'w') as f:
        for i in data:
            f.write("%s\n" % i)
    f.close()

def yaml2envarg(data):
    knr=[]
    ret=[]
    def y2e(d):
        if isinstance(d,dict):
            for i in d:
                knr.append(i)
                y2e(d[i])

        elif isinstance(d,str) or isinstance(d,int):
            ret.append("DCR_%s=%s" % ( '_'.join(knr).upper(), d ))
            del knr[:]
        else:
            print type(d)
            print d
    y2e(data)
    return ret

# メイン
def main():
    logger.info("Config生成")
    config=load_yaml( '%s/etc/config.yaml' % basedir )
    write_file('%s/etc/Config' % basedir, yaml2envarg(config['general']))

    perm=[]
    addr=[]
    for i in config['domains']:
        addr.append("address=/%(name)s/%(addr)s" % i)
        perm.append("%(name)s" % i)
    write_file('%s/data/etc/dnsmasq.d/address.dnsmasq.conf' % basedir,addr)
    write_file('%s/data/etc/tinyproxy.filter.conf' % basedir,perm)

if __name__ == '__main__':
    main()

