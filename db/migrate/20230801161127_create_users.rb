class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :external_id

      t.timestamps
    end

    create_table :user_actions do |t|
      t.string :category, null: false
      t.references :user
      t.references :record, polymorphic: true
      t.json :metadata, default: {}

      t.timestamps
    end
  end
end
