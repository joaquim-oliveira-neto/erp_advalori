class CreateSellers < ActiveRecord::Migration[5.1]
  def change
    create_table :sellers do |t|
      t.string :identification_number
      t.string :company_name
      t.string :company_nickname
      t.string :business_entity
      t.string :registration_number
      t.string :nire
      t.datetime :incorporation_date
      t.string :zip_code
      t.string :address
      t.string :address_number
      t.string :neighborhood
      t.string :address_2
      t.string :state
      t.string :city
      t.string :corporate_capital
      t.string :activity
      t.string :cnae
      t.string :tax_option
      t.references :client, foreign_key: true

      t.timestamps
    end
  end
end
