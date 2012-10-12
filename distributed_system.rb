#!/usr/bin/env ruby

class Node
  attr_reader :name, :addresses, :links, :routing_table
  @@instances = []

  def initialize(name, addresses)
    # Name and address from constructor, route_table hash and list of links start empty
    @name, @addresses, @route_table, @links = name, addresses.to_a, Hash.new, Array.new
    # Each local address gets an entry in the route_table with a cost of 0
    @addresses.each { |local| @route_table[local] = { :link => 'local', :cost => 0 } }
  end

  def store
    @@instances << self
  end

  def add_link(node_name)
    @links << node_name unless @links.include?(node_name)
  end

  def broadcast_table # Messages to links broadcast in a random order
    @links.shuffle.each do |link|
      target = Node.find_by_name(link)
      puts "send #{@name} #{target.name} #{parens_table(@route_table)}"
      # The target has the 'recieve_route_table' method invoked with params of sender's name and table.
      target.send(:receive_route_table, *[@name, @route_table])
    end
  end

  def parens_table(table_hash)
    # Routing table in (addr|link|cost) format sorted with ascending addr.
    table_hash.sort { |x, y| x[0] <=> y[0] }.map { |k, v| "(#{k}|#{v[:link]}|#{v[:cost]})" }.join(" ")
  end

  def show_table
    puts "table #{@name} #{parens_table(@route_table)}"
  end

  def receive_route_table(sender, table)
    puts "receive #{@name} #{sender} #{parens_table(table)}"

    changes = table.map do |target, route|
      new_cost = route[:cost] + 1
      # Update row if any of the following:

      # New destination not previously in routing table
      should_update = @route_table[target].nil?

      # Lower cost link found for existing route
      should_update ||= new_cost < @route_table[target][:cost]

      # The link responsible for an existing route has updated information
      should_update ||= @route_table[target][:link] == sender && new_cost != @route_table[target][:cost]

      # Update action
      @route_table[target] = { :link => sender, :cost => new_cost } if should_update
    end

    #If any update took place, the table should be rebroadcast
    broadcast_table if changes.any?
  end

  def self.find_by_name(name)
    all.select { |node| node.name == name }.first
  end

  def self.all
    @@instances
  end
end

class Link
  attr_reader :endpoints
  @@instances = []

  def initialize(endpoints)
    @endpoints = endpoints
  end

  def store
    @@instances << self
  end

  def self.give_links_to_nodes
    # For each link, endpoint 1 is joined to endpoint 2 and vice versa
    @@instances.each do |link|
      e1, e2 = link.endpoints.take(2)
      Node.find_by_name(e1).add_link(e2)
      Node.find_by_name(e2).add_link(e1)
    end
  end
end

class NodeCommand
  attr_reader :target, :action
  @@queue = []

  def initialize(target, action)
    @target, @action  = target, action
  end

  def enqueue
    @@queue << self
  end

  def self.trigger_actions
    # Each node that has a send action queued has the 'broadcast_table' method invoked
    @@queue.each { |job| Node.find_by_name(job.target).send(:broadcast_table) if job.action == :send }
  end
end

class InputParser
  def self.parse_file(filename)
    File.open(filename).readlines.each { |line| parse_line(line) }
  end

  def self.parse_line(line)
    matches = line.scan /\w+/
    case (object_type = matches.shift)
    when 'node'
      Node.new((name = matches.shift), (addresses = matches)).store
    when 'link'
      Link.new((endpoints = matches.take(2))).store
    when 'send'
      NodeCommand.new((target = matches.first), :send).enqueue
    end
  end
end

# Execution starts here
InputParser.parse_file(File.dirname(__FILE__) + '/network_description.txt')
Link.give_links_to_nodes

NodeCommand.trigger_actions
Node.all.map(&:show_table)
