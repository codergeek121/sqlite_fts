require "sqlite_fts/version"
require "sqlite_fts/railtie"

module SqliteFts
  # Your code goes here... lol
end

# super hacky patches
module ActiveRecord::ConnectionAdapters::SchemaStatements
  def create_virtual_fts_table(table, *columns)
    execute <<~SQL
      CREATE VIRTUAL TABLE #{table}
      USING fts5(#{columns.join(", ")});
    SQL
  end
end

module Helpers
  def extract_columns_from_fts_definition(definition)
    definition.match(/USING fts5\((.*?)\)/)[1].split(", ")
  end
end

module SchemaDumperPatch
  include Helpers

  # TODO: properly introduce a `virtual_tables` in the AR dump method, patch for now
  # add virtual tables after normal tables but before the final "end"
  def tables(stream)
    add_ignored_fts_tables
    super
    dump_virtual_tables(stream)
  end

  def dump_virtual_tables(stream)
    @virtual_fts_tables.pluck("name", "sql").each do |table_name, sql_query|
      columns = extract_columns_from_fts_definition(sql_query).map { "\"#{_1}\"" }.join(", ")
      stream.puts(<<-DSL)
  create_virtual_fts_table "#{table_name}", #{columns}
      DSL
    end
  end

  def add_ignored_fts_tables
    @virtual_fts_tables = find_virtual_fts_tables
    @virtual_fts_tables.each do |virtual_table|

      # ignore the virtual table itself
      @ignore_tables << virtual_table["name"]

      # ignore all the generated shadow tables
      # this is fts5 specific, but good enough for now
      @ignore_tables << "#{virtual_table["name"]}_data"
      @ignore_tables << "#{virtual_table["name"]}"
      @ignore_tables << "#{virtual_table["name"]}_config"
      @ignore_tables << "#{virtual_table["name"]}_content"
      @ignore_tables << "#{virtual_table["name"]}_idx"
      @ignore_tables << "#{virtual_table["name"]}_docsize"
    end
  end

  def find_virtual_fts_tables
    ActiveRecord::Base.connection.execute(<<~SQL)
      SELECT * FROM sqlite_master
      WHERE sql LIKE 'CREATE VIRTUAL TABLE%'
      AND sql LIKE '%fts5%'
    SQL
  end
end

ActiveRecord::SchemaDumper.prepend(SchemaDumperPatch)
