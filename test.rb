require 'net/smtp'

message = <<MESSAGE_END
From: haha <admin@kuandao.com>
To: hoho <25788518@qq.com>
Subject: Just a test

This is a test e-mail message.
MESSAGE_END

# Net::SMTP.start('localhost')

Net::SMTP.start('smtp.exmail.qq.com', 
                465, 
                'smtp.exmail.qq.com', 
                'admin', 'kuandao!@#') do |smtp|
  smtp.send_message message, '25788518@qq.com'
end
