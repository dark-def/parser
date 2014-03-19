class Races < ActiveRecord::Migration
  def self.up
    create_table "races" do |t|
      t.string    "number"
      t.string    "title", :null => false
      t.string    "distance"
      t.string    "going"
      t.string    "prize"
      t.string    "age"
      #t.integer   "track_id", :null => false
      t.datetime  "datetime", :null => false
      t.timestamp
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end