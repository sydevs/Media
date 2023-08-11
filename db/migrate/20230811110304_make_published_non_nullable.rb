class MakePublishedNonNullable < ActiveRecord::Migration[7.0]
  def change
    change_column_default :meditations, :published, false
    change_column_null :meditations, :published, false, false
  end
end
