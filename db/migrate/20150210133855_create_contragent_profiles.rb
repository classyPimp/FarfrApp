class CreateContragentProfiles < ActiveRecord::Migration
  def change
    create_table :contragent_profiles do |t|
      t.string :corporate_form
      t.string :name
      t.string :address
      t.string :director
      t.string :bank_account
      t.string :postal_address
      t.string :contacts
      t.references :contragent, index: true
    end
    add_foreign_key :contragent_profiles, :contragents
  end
end
