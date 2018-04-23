#!/usr/bin/env python 
# -*- coding: utf-8 -*-

import ConfigParser
import string,os,sys
import smtplib
from email import encoders
from email.header import Header
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
from email.mime.base import MIMEBase
from email.utils import parseaddr,formataddr


class Datebase(object):
    def __init__(self,from_addr,password,to_addr,smtp_server,sender,recipients,subject,content,attach_addr):
        self.from_addr = from_addr
        self.password = password
        self.to_addr = to_addr
        self.smtp_server = smtp_server
        self.sender = sender
        self.recipients = recipients
        self.subject = subject
        self.content = content
        self.attach_addr = attach_addr

    def _format_addr(self,s):
        name,addr = parseaddr(s)
        return formataddr(( \
            Header(name,'utf-8').encode(), \
            addr.encode('utf-8') if isinstance(addr,unicode) else addr))


    def date_print(self):
        print self.from_addr
        print self.password 
        print self.to_addr
        print self.smtp_server
        print self.sender
        print self.recipients
        print subject

class Send_mail(Datebase):
    def sendmail(self):
        msg = MIMEText(self.content,'plain','utf-8')
        msg['From'] = self._format_addr(self.sender)
        msg['To'] = self._format_addr(self.recipients)
        msg['Subject'] = Header(self.subject,'utf-8').encode()

        server = smtplib.SMTP(self.smtp_server,25)
#        server.set_debuglevel(1)
        server.login(self.from_addr,self.password)
        server.sendmail(self.from_addr,[self.to_addr],msg.as_string())
        server.quit()


if __name__ == '__main__':
    sendmail_conf = ConfigParser.ConfigParser()
    sendmail_conf_path = os.path.split(os.path.realpath(sys.argv[0]))[0] + '/sendmail.conf'
    sendmail_conf.read(sendmail_conf_path)
    from_addr = sendmail_conf.get("datebase","from_addr")
    password = sendmail_conf.get("datebase","password")
    to_addr = sendmail_conf.get("datebase","to_addr").split(',')
    attach_addr = sendmail_conf.get("datebase","attach_addr")
    smtp_server = sendmail_conf.get("datebase","smtp_server")
    sender = sendmail_conf.get("datebase","sender")
    recipients = sendmail_conf.get("datebase","recipients")
    subject = sendmail_conf.get("datebase","subject")
    content = sendmail_conf.get("datebase","content")

    sys.argv.append(subject)
    sys.argv.append(content)

    if len(sys.argv) >= 1: subject = sys.argv[1]; 
    if len(sys.argv) >= 2: content = sys.argv[2]; 

    for to_address in to_addr:
        Sendmail = Send_mail(from_addr,password,to_address,smtp_server,sender,recipients,subject,content,attach_addr)
        Sendmail.sendmail()

