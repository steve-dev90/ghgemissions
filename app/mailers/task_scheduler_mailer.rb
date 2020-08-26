class TaskSchedulerMailer < ApplicationMailer
  def send_cleared_offer_processed_success_email(processed_files)
    @processed_files = processed_files
    mail( :to => 'stevetorrens70@gmail.com',
      :subject => "Cleared offer files processed #{Time.now.to_s}" )
  end

  def send_cleared_offer_error_email(processed_file, error)
    @processed_file = processed_file
    @error = error
    mail( :to => 'stevetorrens70@gmail.com',
      :subject => "Cleared offer file process error #{Time.now.to_s}" )
  end

  def send_cleared_offer_monthly_processing_complete_email(month_complete)
    @month_complete = month_complete
    mail( :to => 'stevetorrens70@gmail.com',
      :subject => "Cleared offer files monthly processing complete #{Time.now.to_s}" )
  end

  def send_mbie_fuel_data_processing_complete_email(processed_months)
    @processed_months = processed_months
    mail( :to => 'stevetorrens70@gmail.com',
      :subject => "MBIE weekly fuel data processing complete #{Time.now.to_s}" )
  end
end
