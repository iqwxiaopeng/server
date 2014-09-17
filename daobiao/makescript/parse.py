# -*- coding: utf-8 -*-
from pyExcelerator import *
import os
import string

def loadenv():
	global g_env
	g_env = {}
	filename = os.path.join(os.path.dirname(__file__),"daobiao.ini")
	fd = open(filename,"rb")
	lines = fd.readlines()
	for line in lines:
		pos = line.find("#")
		if pos >= 0:
			line = line[:pos]
		if not line:
			continue
		key,val = line.split("=")
		key,val = key.strip(),val.strip()
		if val.isdigit():
			val = int(val)
		g_env[key] = val
	g_env["inputpath"] = os.path.abspath(g_env["inputpath"])
	g_env["outputpath"] = os.path.abspath(g_env["outputpath"])
	fd.close()
	#print "loadenv",g_env
	
def getenv(key,default=None):
	return g_env.get(key,default)


#兼容处理
def real_filename(dstpath,filename):
	real_filename = os.path.join(dstpath,filename)
	if os.path.isabs(real_filename):
		filename = real_filename
	return filename
				
def getxls_abspath(xls_filename):
	if os.path.isabs(xls_filename):
		return xls_filename
	inputpath = getenv("inputpath","")
	if inputpath:
		return os.path.join(inputpath,xls_filename)
	return os.path.abspath(xls_filename)
	

def getscript_abspath(script_filename,iscode=False):
	if os.path.isabs(script_filename):
		return script_filename
	outputpath = getenv("outputpath","")
	if iscode:
		outputpath = getenv("code_outputpath")
	if outputpath:
		return os.path.join(outputpath,script_filename)
	return os.path.abspath(script_filename)

class CSheet(object):
	from_to = {u"，":u",",}
	def __init__(self,values):
		self.m_values = values
		self.m_key2col = {}
		self.m_col2key = {}
		self.trans_table = dict((ord(k),v) for k,v in self.from_to.iteritems())
		#print self.trans_table
		keyrow = getenv("keyrow",2)
		j = 0
		while (keyrow,j) in self.m_values:
			v = self.m_values[(keyrow,j)]
			v = self.parse_str(v)
			self.m_key2col[v] = j
			self.m_col2key[j] = v
			j += 1
		self.m_cols = len(self.m_key2col)
		self.m_rows = 0
		while (self.m_rows,0) in self.m_values:
			self.m_rows += 1
		#print "CSheet.__init__",self.m_key2col,self.m_col2key,self.m_rows,self.m_cols
	
	def parse_str(self,str):
		if type(str) == unicode:
			str = str.translate(self.trans_table)
			return str.encode("utf-8")
		return str
	
	def cols(self):
		return self.m_cols
	
	def rows(self):
		return self.m_rows
	
	def value(self,row,col):
		if type(col) == str:
			col = self.m_key2col[col]
		val = self.m_values.get((row,col),None)
		return self.parse_str(val)
	
	def line(self,row):
		ret = {}
		for col in range(0,self.cols()):
			ret[self.m_col2key[col]] = self.value(row,col)
		return ret
	
class CParser(object):
	def __init__(self,cfg,sheet):
		self.m_cfg = g_env.copy()
		self.m_cfg.update(cfg)
		self.m_sheet = sheet
		
	def linefmt(self,linefmt,line):
		import re
		pat = "%\(([^()]+)\)([^%]{,4}[.fdsr])"	# 提取格式字段:如%(name)fmt => (name,fmt)
		lst = re.findall(pat,linefmt)
		s1 = set([v[0] for v in lst])
		s2 = set(line.keys())
		s = s1 - s2
		#print "linefmt",lst
		if s:
			raise Exception("over format:%s" % s)
		#对None值的默认处理
		for name,fmt in lst:
			if line[name] == None:
				if "d" in fmt or "f" in fmt:
					line[name] = 0.0
				else:
					line[name] = ""
		return linefmt % line
		
	
	def parse(self):
		linefmt = self.m_cfg.get("linefmt","%s")
		startrow = self.m_cfg.get("ignorerows",0)
		lines = []
		for row in xrange(startrow,self.m_sheet.rows()):
			line = self.m_sheet.line(row)
			line = self.linefmt(linefmt,line)
			lines.append(line)
		return lines
	
	def write(self,script_filename,data):
		data = data.strip("\r\n")
		startline = self.m_cfg.get("startline")
		endline = self.m_cfg.get("endline")
		strip_startline = startline.strip()
		strip_endline = endline.strip()
		script_filename = getscript_abspath(script_filename)
		try:
			fd = open(script_filename,"rb")
			lines = fd.readlines()
			fd.close()
		except Exception,e:
			# file not exist?
			lines = []
			parent_dir = os.path.dirname(script_filename)
			if not os.path.isdir(parent_dir):
				os.makedirs(parent_dir)
		start_lineno = end_lineno = -1
		old_data = "".join(lines)
		if lines:
			for lineno,line in enumerate(lines):
				line = line.strip()
				if strip_startline == line:
					start_lineno = lineno
				if strip_endline == line:
					end_lineno = lineno
					#print start_lineno,end_lineno
					assert(start_lineno != -1 and end_lineno > start_lineno)
					break
			if start_lineno == -1 or end_lineno == -1:
				print "ignore filename %r" % script_filename
				return False
			data = "".join(lines[:start_lineno+1]).rstrip("\r\n") + "\n" + data +"\n" + "".join(lines[end_lineno:])
		else:
			data = startline + "\n" + data + "\n" + endline
		if old_data != data:
			fd = open(script_filename,"wb")
			fd.write(data)
			fd.close()
		return True
		
# 提供一个简洁导表借口，对导表有特殊需求的可自行定制
def daobiao(values,script_filename,cfg):
	fmt = cfg.get("fmt")
	if not fmt:
		raise Exception("use daobiao need 'fmt' configuration")
	sheet = CSheet(values)
	parser = CParser(cfg,sheet)
	lines = parser.parse()
	data = "".join(lines)
	data = fmt % data
	parser.write(script_filename,data)
	
if not globals().has_key("initenv"):
	initenv = True
	loadenv()