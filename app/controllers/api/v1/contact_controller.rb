class Api::V1::ContactController < ApplicationController
  def send_email
    pp "GGGGGGGHHHHHHHHHHoyy"
    message_details = {
      name: contact_params[:name],
      subject: contact_params[:subject],
      email: contact_params[:email],
      message: contact_params[:message]
    }
    pp "GOT HERE"
    pp message_details
    ContactMailer.send_contact_email(message_details).deliver
    head :ok
  end

  private
  def contact_params
    params.permit(:name, :subject, :email, :message)
  end
end