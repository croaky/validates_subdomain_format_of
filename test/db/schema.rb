ActiveRecord::Schema.define(:version => 0) do
  create_table :accounts, :force => true do |t|
    t.column "subdomain", :string
  end
end
