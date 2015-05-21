require 'active_record'

ActiveRecord::Base.establish_connection adapter: "sqlite3", database: ":memory:"

ActiveRecord::Schema.define do
  self.verbose = false

  create_table :localships, :force => true do |t|
    t.string :name
    t.integer :phasers
    t.integer :torpedoes
    t.integer :shield
    t.timestamps null: true
  end

  create_table :starships, :force => true do |t|
    t.string :name
    t.integer :phasers
    t.integer :foton_torpedoes
    t.integer :shield
    t.timestamps null: true
  end
end
