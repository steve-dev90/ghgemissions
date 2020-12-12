class ContactMailer < ApplicationMailer
  def send_contact_email(message_detail)
    pp "got here"
    @message_detail = message_detail
    mail( :to => 'stevetorrens70@gmail.com',
      :subject => "Message from Green Foot Prints #{Time.now.to_s}" )
  end
end