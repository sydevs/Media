class AddUuidToMeditation < ActiveRecord::Migration[7.0]
  def change
    add_column :meditations, :uuid, :string
  end
end
