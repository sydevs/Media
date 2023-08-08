class ChangeNarratorToEnum < ActiveRecord::Migration[7.0]
  def change
    change_column_default :meditations, :narrator, from: 1, to: 0
  end
end
