require "awesome_print"
require_relative './example'
require 'terminal-table'


module Hlpr
  def self.show_dictionary_as_table(dic, title, num_entries_to_show=dic.size)
    sample_entry = dic[0]
    instance_vars = sample_entry.instance_variables
    table = Terminal::Table.new title:      title,
                                headings:   instance_vars.map(&:to_s),
                                rows:       dic[0,num_entries_to_show].map {|entry| instance_vars.map {|v| entry.instance_variable_get(v)}}
    puts table
  end
end

Example.new do |client|
  hts = client.house_transactions
  Hlpr.show_dictionary_as_table(hts,"House Transactions",30)
end


