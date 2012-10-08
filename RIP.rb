#!/usr/bin/env ruby

app_dir = File.dirname(__FILE__)

%w{input_parser node link node_command}.each do |inc|
  require app_dir + "/lib/#{inc}.rb"
end

InputParser.parse_file(app_dir + '/network_description.txt')

Link.give_links_to_nodes

# From now on, all changes to the routing table are broadcast
Node.all.each { |node| node.broadcasting = true }

NodeCommand.trigger_actions

Node.all.map(&:show_table)
