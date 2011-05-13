# -*- coding: utf-8 -*-

ROOT = File.dirname __FILE__
$: << ROOT

require 'common'
require "pony"

confs = [
         {body: get_body_html(1), file: "test"},
         {body: get_body_html(1), file: "qq_m_90_01"},
         {body: get_body_html(2), file: "qq_f_90_02"},
         {body: get_body_html(3), file: "qq_m_80_01"},
         {body: get_body_html(4), file: "qq_f_90_01"},
         {body: get_body_html(2), file: "qq_f_80_03"},
         {body: get_body_html(1), file: "m_m_90_01"},
         {body: get_body_html(2), file: "m_f_90_01"},
         {body: get_body_html(3), file: "m_m_80_01"},
         {body: get_body_html(4), file: "m_f_90_01"},
         {body: get_body_html(2), file: "m_f_80_02"},
]

conf = confs[ARGV[0].to_i]
file_name = conf[:file]
body_html = conf[:body]
log_name = conf[:file]
body_txt = get_body_txt

i=0
# send_smtp(email_r, "25788518@qq.com", subject_r('') , body_txt, body_html)

puts file_name
file = File.open(ADDRESS_PATH+file_name+".txt", "r")
file.each_line do |line|
 line = line.chomp
 puts line
 if(line =~ /.+@.+\..+/ && (line =~ /-/) != 0)
   unless send_smtp("", line, subject_r(line.sub(/@.+/, '')), body_txt, body_html)
     log "发送失败:"+line, "error"
     puts "发送失败:"+line
   end
   log i.to_s + " : " + ARGV.to_s + " : " + line, log_name
   sleep 3
   if i%5000 == 0
     if file_name =~ /qq/
       send_smtp("", "25788518@qq.com", subject_r(file_name + line.sub(/@.+/, '')) , body_txt, body_html)
     else
       send_smtp("", "siyang1982@gmail.com", subject_r(file_name + line.sub(/@.+/, '')), body_txt, body_html)
     end
     sleep 1
   end
   i += 1
 end
end
file.close
File.delete(ADDRESS_PATH+file_name+".txt")
notice(file_name+"发送完毕:)")
