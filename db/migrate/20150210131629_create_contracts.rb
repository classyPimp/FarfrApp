class CreateContracts < ActiveRecord::Migration
  def change
    create_table :contracts do |t|
      t.string :number
      t.string :date
      t.string :subject
      t.string :short_description
      t.references :parent, index: true
      t.text :log

      t.timestamps null: false
    end
    add_foreign_key :contracts, :parents
  end
end
