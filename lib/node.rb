class Node
  attr_reader :name, :addresses, :links, :routing_table
  @@instances = []

  def initialize(name, addresses)
    @name = name
    @route_table = Hash.new
    @addresses = Array(addresses)
    @addresses.each { |local| @route_table[local] = { :link => 'local', :cost => 0 } }
    @links = []
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
      target.send(:receive_route_table, *[@name, @route_table])
    end
  end

  def parens_table(table_hash) # Routing table in (addr|link|cost) format sorted with ascending addr.
    table_hash.sort { |x, y| x[0] <=> y[0] }.map { |k, v| "(#{k}|#{v[:link]}|#{v[:cost]})" }.join(" ")
  end

  def show_table
    puts "table #{@name} #{parens_table(@route_table)}"
  end

  def receive_route_table(sender, table)
    puts "receive #{@name} #{sender} #{parens_table(table)}"

    changes = table.map do |target, route|
      new_cost = route[:cost] + 1
      should_update = @route_table[target].nil? # New destination not previously in routing table
      should_update ||= new_cost < @route_table[target][:cost] # Lower cost link found for existing route
      # The link responsible for an existing route has updated information
      should_update ||= @route_table[target][:link] == sender && new_cost != @route_table[target][:cost]

      if should_update
        @route_table[target] = { :link => sender, :cost => new_cost }
      else
        false
      end
    end

    broadcast_table if changes.any?
  end

  def self.find_by_name(name)
    all.select { |node| node.name == name }.first
  end

  def self.all
    @@instances
  end

end
