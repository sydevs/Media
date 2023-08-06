class AddPublishedToMeditation < ActiveRecord::Migration[7.0]
  def change
    add_column :meditations, :published, :bool
  end
end
