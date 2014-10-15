import sys
import os
import time
from shutil import *

def backup_db(dirname):
    assert os.path.isdir(dirname),"not dirname"
    for root,dirs,filenames in os.walk(dirname):
        #print root,dirs,filenames
        for filename in filenames:
            filename = os.path.join(root,filename)
            if filename.endswith(".rdb") or filename.endswith("aof"):
                now=time.strftime("%Y%m%d%H%M%S",time.localtime())
                backup_filename = "%s_%s.bak" % (filename,now)
                tmp_filename = backup_filename + ".tmp"
                copy2(filename,tmp_filename)  # preserve attr
                copy2(tmp_filename,backup_filename)
                os.remove(tmp_filename)
        break

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print "backup_db arguments != 2"
        exit(0)
    dirname = sys.argv[1]
    backup_db(dirname)
