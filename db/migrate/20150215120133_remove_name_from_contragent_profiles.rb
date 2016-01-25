class RemoveNameFromContragentProfiles < ActiveRecord::Migration
  def change
    remove_column :contragent_profiles, :name, :string
    remove_column :contragent_profiles, :corporate_form, :string
  end
end
