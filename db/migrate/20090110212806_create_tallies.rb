class CreateTallies < ActiveRecord::Migration
  def self.up
    create_table :tallies do |t|

      t.integer     :int_val
      t.string      :str_val
      t.text        :text_val
      t.boolean     :bool_val
      t.integer     :user_id
      t.belongs_to  :subject
      t.timestamps

    end
  end

  def self.down
    drop_table :tallies
  end
end
