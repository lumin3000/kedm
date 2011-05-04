# -*- coding: utf-8 -*-
require "gmail"

body_txt = File.read("body.txt")
file = File.open("list.txt", "r")
log = File.open("log.txt", "a")

def connect_gmail(name)
  Gmail.connect(name, "kuandao123")
end

gmail = []
gmail << connect_gmail("kuandao004")
#gmail << connect_gmail("kuandao005")

i = 0
file.each_line do |line|
  i += 1
  print '>'+i.to_s
  g = gmail[i%gmail.length]
  g.deliver do
    content_type 'text/html; charset=UTF-8'
    to line.chomp
    subject "2012就快到了，你有船票了么？"
    body body_txt
  end
  log.puts '>'+Time.now.to_s+':'+i.to_s+':'+line.to_s
  sleep 1
end
file.close
gmail.each do |g|
  g.logout
end
log.close
