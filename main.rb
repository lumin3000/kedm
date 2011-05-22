# -*- coding: utf-8 -*-

ROOT = File.dirname __FILE__
$: << ROOT

require 'mail'
require 'common'
require 'config'

confs = [
         {body: get_body_html(1), file: "test"},
         {body: get_body_html(1), file: "qq_m_90_01"},
         {body: get_body_html(2), file: "qq_f_90_01"},
         {body: get_body_html(3), file: "qq_m_80_01"},
         {body: get_body_html(4), file: "qq_f_90_01"},
         {body: get_body_html(1), file: "qq_f_80_01_l"},
         {body: get_body_html(1), file: "m_m_90_01"},
         {body: get_body_html(2), file: "m_f_90_01"},
         {body: get_body_html(3), file: "m_m_80_01"},
         {body: get_body_html(4), file: "m_f_90_01"},
         {body: get_body_html(5), file: "m_f_80_01"},
]

conf = confs[ARGV[0].to_i]
file_name = conf[:file]
body_html = conf[:body]
log_name = conf[:file]
body_txt = get_body_txt

i=0

puts file_name
file = File.open(ADDRESS_PATH+file_name+".txt", "r")
file.each_line do |line|
 line = line.chomp
 puts line
 if(line =~ /.+@.+\..+/ && (line =~ /-/) != 0)
 send_mail(email_r, line, subject_r(line.sub(/@.+/, '')), body_txt, body_html)
 log i.to_s + " : " + ARGV.to_s + " : " + line, log_name
 sleep 1
 if i%30000 == 0
   if file_name =~ /qq/
     send_mail(email_r, "25788518@qq.com", subject_r(file_name + line.sub(/@.+/, '')) , body_txt, body_html)
   else
     send_mail(email_r, "siyang1982@gmail.com", subject_r(file_name + line.sub(/@.+/, '')), body_txt, body_html)
   end
   sleep 10
 end
 i += 1
 end
end
file.close
File.delete(ADDRESS_PATH+file_name+".txt")
# notice(file_name+"发送完毕:)")
