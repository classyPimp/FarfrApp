class ViewServices::User

  def self.users_for_select
    approvers_for_select = User.select(:name, :id).all.collect do |user|
      [user.name, user.id]
    end
  end

  def self.contragents_for_select
    contragents_for_select = Contragent.select(:name, :id).all.collect do |contragent|
      [contragent.name, contragent.id]
    end
  end
  
end