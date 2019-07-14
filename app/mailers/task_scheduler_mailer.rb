class TaskSchedulerMailer < ApplicationMailer
  def send_cleared_offer_processed_success_email
    mail( :to => 'stevetorrens70@gmail.com',
    :subject => 'Thanks for signing up for our amazing app' )
  end
end
