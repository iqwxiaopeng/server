# -*- coding: utf-8 -*-
from pyExcelerator import *
from makescript.parse import *
import os
import sys

def append_if_not_exist(filename,cond,append_data):
    fd = open(filename,"rb")
    data = fd.read()
    found = True if data.find(cond) >= 0 else False
    fd.close()
    if not found:
        fd = open(filename,"wb")
        fd.write(data + "\n" + append_data)
        fd.close()

def parse_item(sheet_name,sheet,dstpath):
    print("parse %s..." % sheet_name)
    cfg = {
        "startline" : "--<<item 导表开始>>",
        "endline" : "--<<item 导表结束>>",
        "linefmt" :
"""
require "script.item"
citem%(sid)d = class("citem%(sid)d",citem)
function citem%(sid)d:init(pid)
    citem.init(self,pid)
    self.sid = %(sid)d
    self.name = "%(name)s"
    self.magic_immune = %(magic_immune)d,
    self.dieeffect = %(dieeffect)d,
    self.assault = %(assault)d,
    self.buf = %(buf)d,
    self.warcry = %(warcry)d,
    self.lifecircle = %(lifecircle)d,
    self.sneer = %(sneer)d,
    self.magic = %(magic)d,
    self.magic_hurt = %(magic_hurt)d,
    self.max_mount = %(max_mount)d,
    self.data = {}
""",
    }
    if not os.path.isdir(dstpath):
        os.makedirs(dstpath)
    filename_pat = "item%d.lua"
    require_pat = "require \"script.item.item%d\""
    assign_pat = "itemmodule[%d] = citem%d"
    append_pat = \
"""
end --导表生成
function citem%d:load(data)
    if not data then
        return
    end
    -- todo: load data
end

function citem%d:save()
    local data = {}
    -- todo: save data
    return data
end
"""
    cond = "end --导表生成"
    require_list = []
    assign_list = []
    sheet = CSheet(sheet)
    parser = CParser(cfg,sheet)
    ignorerow = parser.m_cfg.get("ignorerows",0) 
    for row in range(ignorerow,sheet.rows()):
        line = sheet.line(row)        
        sid = line["sid"]
        data = cfg["linefmt"] % line
        filename = os.path.join(dstpath,filename_pat % sid)
        parser.write(filename,data)
        require_list.append(require_pat % sid)
        assign_list.append(assign_pat % (sid,sid))
        append_data = append_pat % (sid,sid)
        append_if_not_exist(filename,cond,append_data)
    modfilename = os.path.join(dstpath,"itemmodule.lua")
    moddata = \
"""
itemmodule = {}
%s
%s
return itemmodule
""" % ("\n".join(require_list),"\n".join(assign_list))
    parser.write(modfilename,moddata)
    print("parse %s ok" % sheet_name)

def parse(xlsfilename,dstpath):
    parses = {
        "item" : parse_item,
    }
    sheets = parse_xls(xlsfilename) 
    for sheet_name,sheet_data in sheets:
        parse = parses[sheet_name]
        parse(sheet_name,sheet_data,dstpath)


if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("usage python parse_item.py xlsfilename dstpath")
        exit(0)
    xlsfilename = sys.argv[1]
    dstpath = sys.argv[2]
    parse(xlsfilename,dstpath)
