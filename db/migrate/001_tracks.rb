class Tracks < ActiveRecord::Migration
  def self.up
    create_table "tracks" do |t|
      t.string  "title", :null => false
      t.timestamp
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end