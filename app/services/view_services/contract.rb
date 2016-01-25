class ViewServices::Contract

  attr_reader :pending_confirmations

  def resolve_pending_confirmations(pending_confirmations_collection)
    confirmations = {}
    confirmations[:kept_at] = []

    unless pending_confirmations_collection.blank?
      pending_confirmations_collection.each do |confirmation|
        if confirmation.type = 'ContractKeptAtConfirmation'
          confirmations[:kept_at] << confirmation
        end
      end
    end

    @pending_confirmations = confirmations
  end


end