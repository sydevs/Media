class AddUserTracking < ActiveRecord::Migration[7.0]
  def change
    drop_table :user_actions do |t|
      t.string :category, null: false
      t.references :user
      t.references :record, polymorphic: true
      t.json :metadata, default: {}

      t.timestamps
    end

    create_table :meditation_views do |t|
      t.references :meditation, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :progress, null: false
      t.integer :rating
      t.timestamps
    end

    create_table :user_meditations do |t|
      t.references :meditation, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end

    add_column :users, :seen, :integer, null: false, default: 0, limit: 8
    add_column :users, :unlocked, :integer, null: false, default: 0, limit: 8
    add_column :users, :path_progress, :integer, default: 0, null: false
    add_column :users, :path_progressed_at, :datetime, default: Time.now, null: false
  end
end
