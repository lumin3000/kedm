# -*- coding: utf-8 -*-
require 'mail'

def r_name
  %w[commic desktop admin user].sample
end

def r_s
  # %w[a b c d e f g].sample
  %w[1 2 3 4 5 6 7 8 9 0].sample.to_s
end

def r_b
  %w[:) :P :D :( :O :-X B-) -_- >_< ^_^ T_T @_@ *_*].sample
end

def r_domain
  %w[m mail email i ma mi ml].sample+'.'+%w[kuandao].sample+'.'+%w[cn com cc].sample
end

def email_r
  r_name+r_s+"@"+r_domain
end

def subject_r
  "通往2012的船票 "+r_b
end

list_file = "list.txt"
log_file = "log.txt"

def send_mail(email_from, email_to, email_subject, body_txt, body_html)
  mail = Mail.new do
    from email_from
    to email_to
    subject email_subject
    text_part do
      content_type 'text/plain; charset=UTF-8'
      body body_txt
    end
    html_part do
      content_type 'text/html; charset=UTF-8'
      body body_html
    end
  end
  # mail.to_s
  mail.delivery_method :sendmail
  mail.deliver!
end

def send_list
end

body_txt = File.read('body.txt')
body_html = File.read('body.html')
log = File.open(log_file, "a") 
file = File.open(list_file, "r")
file.each_line do |line|
  send_mail(email_r, line.chomp, subject_r, body_txt, body_html)
  log.puts line
  print line
  sleep 1
end
log.close
