class CreateBoards < ActiveRecord::Migration
  def self.up
    create_table :boards do |t|
      t.string :title
      t.string :description
      t.boolean :is_public, :default => true
      t.belongs_to :user
      t.timestamps
    end
  end

  def self.down
    drop_table :boards
  end
end
