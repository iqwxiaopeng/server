import sys
import re
from sendmail import sendmail

normal_line_pat = re.compile("^\[:[0-9a-f]+ .*$\]")
err_line_pat = re.compile("^\[:[0-9a-f]+\] sknerror .*$")
lineno = 0

def getlineno():
    try:
        fd = open("error_monitor.line","rb")
        lineno = fd.readline()
        fd.close()
    except Exception,e:
        lineno = 0
        setlineno(lineno)
    return int(lineno)

def setlineno(lineno):
    fd = open("error_monitor.line","wb")
    fd.write(str(lineno))
    fd.close()

def find_err(filename):
    errlist = []
    lineno = getlineno()
    fd = open(filename,"rb") 
    lines = fd.readlines()
    startline = lineno
    open_flag = False
    while lineno < len(lines):
        line = lines[lineno]
        if re.match(err_line_pat,line):
            if not open_flag:
                startline = lineno
            open_flag = True
        elif re.match(normal_line_pat,line):
            if open_flag:
                open_flag = False
                err = "\n".join(lines[startline:lineno])
                errlist.append(lines[startline:lineno])
        lineno += 1
    fd.close()
    setlineno(lineno)
    if open_flag:
        err = "\n".join(lines[startline:])
        errlist.append(err)
    return errlist


def report(to_list,subject,errlist):
    for err in errlist:
        sendmail(to_list,subject,errlist)

if __name__ == "__main__":
    filename = sys.argv[1] # need absolute path
    to_list = sys.argv[2]
    subject = sys.argv[3]
    errlist = find_err(filename)
    report(to_list,subject,errlist)
