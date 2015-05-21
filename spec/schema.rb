require 'active_record'

ActiveRecord::Base.establish_connection adapter: "sqlite3", database: ":memory:"

ActiveRecord::Schema.define do
  self.verbose = false

  create_table :natives, :force => true do |t|
    t.string  :name
    t.string  :document
    t.integer :age
    t.timestamps null: true
  end

  create_table :foreigners, :force => true do |t|
    t.string  :name
    t.integer :years_lived
    t.timestamps null: true
  end
end
