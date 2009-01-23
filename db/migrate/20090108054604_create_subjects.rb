class CreateSubjects < ActiveRecord::Migration
  def self.up
    create_table :subjects do |t|
      t.string :title
      t.string :url
      t.belongs_to :board
      t.boolean :is_public
      t.boolean :inherits , :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :subjects
  end
end
