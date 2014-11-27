import sys
import types
import smtplib
from email.mime.text import MIMEText

def sendmail(to_list,subject,content):
    mail_host = "smtp.qq.com"
    mail_user = "2457358113@qq.com"
    #mail_pass = "errorpassword"
    mail_pass = "lgllmj12200205"
    me = "2457358113@qq.com" 
    msg = MIMEText(content,_subtype="plain",_charset="utf-8")
    msg["Subject"] = subject
    msg["From"] = me
    msg["To"] = to_list
    if type(to_list) == types.ListType:
            msg["To"] = ";".join(to_list)
    if type(to_list) == str:
        to_list = to_list.split(";")
    try:
       server = smtplib.SMTP()
       print "start connect"
       server.connect(mail_host)
       print "connect ok"
       server.login(mail_user,mail_pass)
       print "login ok"
       server.sendmail(me,to_list,msg.as_string())
       print "sendmail ok"
       server.close()
       return True
    except Exception,e:
       print(e)
       return False

if __name__ == "__main__":
    for i in sys.argv:
        print i
    assert len(sys.argv) == 4,"send mail argument count != 3"
    sendmail(sys.argv[1],sys.argv[2],sys.argv[3])
