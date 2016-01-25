class ContractKeptAtConfirmationController < ApplicationController


#--------------ACTION METHODS
  def update
    if ContractKeptAtConfirmation.mass_confirm((params[:contract_kept_at_confirmation][:confirmations_ids] - ["0"]), 
                              current_user.id)
      respond_to do |f|
        f.json {render json:{status: "OK", confirmed: (params[:contract_kept_at_confirmation][:confirmations_ids] - ["0"])}, status: :ok}
      end
    else
      raise "CONTKEPTAT#MASSUPDATE"
      respond_to do |f|
        f.json {render json: {status: "error"}, status: :error}
      end
    end
  end

#----------------PARAMS METHODS

  
end
