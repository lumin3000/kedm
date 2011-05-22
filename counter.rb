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
    break if i>7
    puts line if i>=7
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
    line.split(" : ")[2] && (arr << line.split(" : ")[2].chomp)
  end
  file.close
  group(arr).each do |key, value|
    $hash[key] && (puts $hash[key][:uri] + "(#{$hash[key][:comment]}) : "+value.to_s)
  end
  puts "------------------"
end

def register_st
  arr = []
  file = File.open("log/register_refer_#{$date}.log", 'r')
  puts "--- 注册统计"
  file.each_line do |line|
    line.split(" : ")[5] && (arr << line.split(" : ")[5].chomp)
  end
  file.close
  h = group(arr)
  # $hash.each do |key, value|
  #   puts key
  #   puts value + " : " + h[key.to_sym].to_s
  # end
  h.each do |key, value|
    $hash[key] && (puts $hash[key][:uri] + "(#{$hash[key][:comment]}) : "+value.to_s)
  end
  puts "------------------"
end

$date = `/bin/date -d yesterday +%y%m%d`.chomp
$date2 = `/bin/date -d yesterday +%m.%d`.chomp
$hash = {
  "je124c3oomh6qc00040" => {uri: "signin", comment: "美女"}, # 美女（pretty）
  "je12bbjoomh7vrg001e" => {uri: "tongren", comment: "腐"}, # 腐 （腐 童年动漫）
  "je12ekjoomh8ch00005" => {uri: "leng", comment: "笑话"}, # 笑话 （冷笑话 mars）
  "je12hijoomh8dbg000p" => {uri: "chongwu", comment: "动物"}, # 动物 （有意思的小生物 猫）
  "jdpai1joomh0f3g000n" => {uri: "yingshi", comment: "运营主管 高小滢"}, # 运营主管 高小滢
  "je3csejoomh357g000v" => {uri: "yvjicomic", comment: "动漫运营 程雨婧"}, # 动漫运营 程雨婧
  "jdu6s8joomhda9g002c" => {uri: "shishangwozuiai", comment: "时尚运营 丁怡"}, # 时尚运营 丁怡
  "je0k9ljoomh87cg000i" => {uri: "sheyinglover", comment: "摄影运营 陈娟"}, # 摄影运营 陈娟
  "je8toujoomh4cp0003n" => {uri: "shuiyangxinqing", comment: "星座天天测 高小滢"},
  "je8u30joomh4s50001v" => {uri: "yueye", comment: "爱车爱越野 高小滢"},
  "je8s4f3oomhde1g002n" => {uri: "xinwen", comment: "天下大事一朝闻 高小滢"},
  "je8ropjoomhdbf00005" => {uri: "loveyou", comment: "爱在进行时 丁怡"},
  "je8q8k3oomhar5g0008" => {uri: "wushibuhuan", comment: "无食不欢 丁怡"},
  "je8tfhjoomh44g00009" => {uri: "aiyinle", comment: "爱_音_乐 丁怡"},
  "je8tel3oomh3q8g004g" => {uri: "traveleveryday", comment: "灿烂只为你2011 陈娟"},
  "je8u5jjoomh5bq0000a" => {uri: "lovingbooks", comment: "读书新体验 陈娟"},
  "je8u01joomh4r9g000e" => {uri: "movieonline", comment: "影视最爱 陈娟"},
  "je8tqejoomh4i600011" => {uri: "newsonline", comment: "欲晓天下事 陈娟"},
  "je7i7gjoomh8vlg000o" => {uri: "shuchong", comment: "汀轩书虫 程雨婧"},
  "je8u1bjoomh4s500003" => {uri: "huli", comment: "狐狸科的大耳朵 程雨婧"},
  "je8v2g3oomh8gl00019" => {uri: "jingzhi", comment: "精致的愿望 程雨婧"},
  "je8vdqjoomh98u00022" => {uri: "bingxiang", comment: "冰箱里的故事 程雨婧"},
  "jebhq43oomh2l4g000a" => {uri: "pandaho", comment: "潘大吼"},
  "jebldu3oomh4ocg0075" => {uri: "thefairylady", comment: "The Fairy Lady"},
  "jegpjc3oomhdig0000h" => {uri: "guojia", comment: "guojia"},
}
puts "------ #{$date}统计 ------"
system "scp root@117.79.233.23:/root/log/mail_#{$date}.txt log"
mail_st

`scp huang@kuandao.com:/var/kuan/current/log/invitation_refer.log log`
system "egrep \"^#{$date2}\" log/invitation_refer.log > log/invitation_refer_#{$date}.log"
invitation_st

`scp huang@kuandao.com:/var/kuan/current/log/register_refer.log log`
system "egrep \"^#{$date2}\" log/register_refer.log > log/register_refer_#{$date}.log"
register_st
puts "------ END  ------"
