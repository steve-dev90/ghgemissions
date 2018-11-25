class Power::UserEmissions
  def initialize(user_energy)
    @user_energy = user_energy
  end

  def call
    obtain_profile
    obtain_system_emissions
    calculate_user_emissions
  end

  def obtain_profile
  end 
  
  def obtain_system_emissions
  end
  
  def calculate_user_emissions
  end  
end
