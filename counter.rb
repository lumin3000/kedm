# -*- coding: utf-8 -*-
### count daily delivered mail
### log file should be generated on server: /usr/sbin/pflogsumm -d yesterday /var/log/mail.log > /root/log/mail_`date -d yesterday +%y%m%d`.txt (suggest add to cron)

def group(arr)
  arr.inject(Hash.new(0)) { |h, e| h[e] += 1 ; h }
end

def mail_st
  file = File.open("log/mail_#{$date}.txt", 'r')
  i = 0
  puts "--- 昨日邮件统计"
  file.each_line do |line|
    break if i>14
    puts line if i>=6
    i += 1
  end
  file.close
  puts "------------------"
end

def invitation_st
  arr = []
  file = File.open("log/invitation_refer_#{$date}.log", 'r')
  puts "--- 邀请页统计"
  file.each_line do |line|
    arr << line.split(" : ")[2]
  end
  file.close
  group(arr).each do |key, value|
    $hash[key] && (puts $hash[key]+" : "+value.to_s)
  end
  puts "------------------"
end

def register_st
  arr = []
  file = File.open("log/register_refer_#{$date}.log", 'r')
  puts "--- 注册统计"
  file.each_line do |line|
    arr << line.split(" : ")[5]
  end
  file.close
  group(arr).each do |key, value|
    $hash[key] && (puts $hash[key]+" : "+value.to_s)
  end
  puts "------------------"
end

$date = `/bin/date -d yesterday +%y%m%d`.chomp
$date2 = `/bin/date -d yesterday +%m.%d`.chomp
$hash = {
  "je124c3oomh6qc00040" => "signin", # 美女（pretty）
  "je12bbjoomh7vrg001e" => "tongren", # 腐 （腐 童年动漫）
  "je12ekjoomh8ch00005" => "leng", # 笑话 （冷笑话 mars）
  "je12hijoomh8dbg000p" => "chongwu", # 动物 （有意思的小生物 猫）
}
puts "------ #{$date}统计 ------"
#system "scp root@117.79.233.23:/root/log/mail_#{$date}.txt log"
mail_st

#`scp huang@kuandao.com:/var/kuan/current/log/invitation_refer.log log`
system "egrep \"^#{$date2}\" log/invitation_refer.log > log/invitation_refer_#{$date}.log"
invitation_st

`scp huang@kuandao.com:/var/kuan/current/log/register_refer.log log`
system "egrep \"^#{$date2}\" log/register_refer.log > log/register_refer_#{$date}.log"
register_st
puts "------ END  ------"
