class CreateRewards < ActiveRecord::Migration[8.0]
  def change
    create_table :rewards do |t|
      t.string :name, null: false
      t.text :description
      t.integer :points_cost, null: false
      t.boolean :is_active, default: true, null: false

      t.timestamps
    end
  end
end
