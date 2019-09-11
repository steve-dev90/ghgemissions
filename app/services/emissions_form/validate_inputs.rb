class EmissionsForm::ValidateInputs

  def initialize(form_params)
    @start_date = form_params[:start_date_submit]
    @end_date = form_params[:end_date_submit]
    @user_energy = form_params[:user_energy]
  end

  def call
    pp "BOO"
    pp @start_date
  end

end