require "test_helper"

class SqliteFtsTest < ActiveSupport::TestCase
  test "it has a version number" do
    assert SqliteFts::VERSION
  end

  test "it dumps the virtual table in schema.rb" do
    io = StringIO.new
    
    ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, io)

    assert_equal migration_fixture('virtual_users_table.rb').read, io.string
  end
end
