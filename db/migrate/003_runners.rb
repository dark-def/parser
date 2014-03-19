class Runners < ActiveRecord::Migration
  def self.up
    create_table "runners" do |t|
      t.integer "race_id"
      t.string    "pos"
      t.string    "btn"
      t.string    "name", :null => false
      t.string    "tfr"
      t.string    "age"
      t.string    "weight"
      t.string    "eq"
      t.string    "jockey"
      t.string    "trainer"
      t.string    "rating"
      t.string    "isp"
      t.string    "bsp"
      t.string    "hilo"
      t.timestamp
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end