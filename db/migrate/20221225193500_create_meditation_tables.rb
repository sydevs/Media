class CreateMeditationTables < ActiveRecord::Migration[7.0]
  def change
    create_table :meditations do |t|
      t.string :title
      t.integer :duration

      t.timestamps
    end

    create_table :frames do |t|
      t.string :title
      t.string :tags

      t.timestamps
    end

    create_table :keyframes do |t|
      t.references :media, null: false, polymorphic: true
      t.references :frame, null: false, foreign_key: true
      t.integer :seconds

      t.timestamps
    end
  end
end
