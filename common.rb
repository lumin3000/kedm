# -*- coding: utf-8 -*-
require "logger"

LOG_PATH = "log/"
MAIL_PATH = "mail/"
ADDRESS_PATH = "data/"

### log ###
def log(v, name)
  l = Logger.new("#{LOG_PATH}log_#{name}.txt")
  l.info v
end

### random generator ###
def r_name
  %w[commic desktop admin user siyang].sample
end

def r_s
  # %w[a b c d e f g].sample
  %w[1 2 3 4 5 6 7 8 9 0].sample.to_s
end

def r_b
  %w[:) :P :D :( :O :-X B-) -_- >_< ^_^ T_T @_@ *_* o(∩_∩)o].sample
end

def r_domain
  %w[m mail email i ma mi ml].sample+'.'+%w[kuandao].sample+'.'+%w[cn com cc].sample
end

def email_r
  r_name+r_s+"@"+r_domain
  "宽岛 <webmaster@mail.kuandao.com>"
end

def subject_r(str)
  t1 = %w[你好 Hello HEY HI 您好].sample
  t2 = ["宽岛欢迎你",
   "来自宽岛的邀请信",
   "邀请#{str}登岛通知书",
   "2012快来了，#{str}，你有船票么？",
   "#{str}你好，这是来自宽岛的邀请",
  ].sample
  puts   t1 + ", " + t2 + " " + r_b
  t1 + ", " + t2 + " " + r_b
end

### mail content ###
def get_body_txt(i = '')
  File.read("#{MAIL_PATH}body#{i}.txt")
end

def get_body_html(i = '')
  File.read("#{MAIL_PATH}body#{i}.html")
end

### send mail ###
def send_mail(email_from, email_to, email_subject, body_txt, body_html)
  mail = Mail.new do
    from email_from
    to email_to
    subject email_subject
    text_part do
      content_type 'text/plain; charset=UTF-8'
      body body_txt
    end
    body_html && html_part do
      content_type 'text/html; charset=UTF-8'
      body body_html
    end
  end
  mail.delivery_method :sendmail
  mail.deliver!
end

def send_smtp(email_from, email_to, email_subject, body_txt, body_html)
  user = %w[admin kuandao001 kuandao002 kuandao003].sample
  Pony.options = {
    :from => "宽岛 <#{user}@kuandao.com>", 
    :via => :smtp, 
    :via_options => { 
      :address        => 'smtp.exmail.qq.com',
      :port           => '25',
#      :enable_starttls_auto => true,
      :user_name      => "#{user}@kuandao.com",
      :password       => 'kuandao!@#',
      :authentication => :plain,
      :domain         => 'smtp.exmail.qq.com',
    }
  }
  begin
    Pony.mail(
            :to => email_to,
            :subject => email_subject,
            :body => body_txt,
            :html_body => body_html
            )
    true
  rescue
    puts $!
    puts user
    false
  end
end


def op_line(line)
end

def notice(msg)
  send_mail(email_r, "25788518@qq.com", "kuandao邮件提醒" , "", msg)
end
