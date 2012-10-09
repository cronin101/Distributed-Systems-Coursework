#!/usr/bin/env ruby
%w{input_parser node link node_command}.each { |inc| require File.dirname(__FILE__) + "/lib/#{inc}.rb" }

InputParser.parse_file(File.dirname(__FILE__) + '/network_description.txt')
Link.give_links_to_nodes

NodeCommand.trigger_actions
Node.all.map(&:show_table)
