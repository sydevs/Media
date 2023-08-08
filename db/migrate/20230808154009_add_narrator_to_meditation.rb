class AddNarratorToMeditation < ActiveRecord::Migration[7.0]
  def change
    add_column :meditations, :narrator, :integer, null: false, default: 1
  end
end
