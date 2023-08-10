class AddCreditToMusic < ActiveRecord::Migration[7.0]
  def change
    add_column :musics, :credit, :string
  end
end
