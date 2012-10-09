class Node
  @@instances = []

  attr_reader :name, :addresses, :links, :routing_table
  attr_accessor :broadcasting

  def initialize(name, addresses)
    @name = name
    @routing_table = Hash.new
    @broadcasting = false
    (@addresses = Array(addresses)).each { |local| @routing_table[local] = ['local',0] }
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
      puts "send #{@name} #{target.name} #{parens_table(@routing_table)}"
      target.send(:receive_routing_table, *[@name, @routing_table])
    end
  end

  def parens_table(table_hash) # Routing table in (addr|link|cost) format sorted with ascending addr.
    table_hash.sort { |a, b| a[0] <=> b[0] }.map { |k, v| "(#{k}|#{v.first}|#{v.last})" }.join(" ")
  end

  def show_table
    puts "table #{@name} #{parens_table(@routing_table)}"
  end

  def receive_routing_table(sender, table)
    puts "receive #{@name} #{sender} " + table.map { |k, v| "(#{k}|#{v.first}|#{v.last})" }.join(" ")
    changes = false
    update_row = lambda { |k, v| (@routing_table[k] = [sender, v.last + 1]) && (changes = true) }

    table.each do |k, v|
              # "If there is a new destination, add that row to the table"
        update_row.call(k,v) if (@routing_table[k].nil?) ||
              # "If there is a lower cost route to an existing node, update the appropriate row"
            ((v.last + 1) < @routing_table[k].last) ||
              # "If the table was recieved on link N, replace all differing rows with N as the link"
            (@routing_table[k].first == sender && @routing_table[k].last != (v.last + 1))
    end
    broadcast_table if changes && @broadcasting
  end

  def self.find_by_name(name)
    all.select { |node| node.name == name }.first
  end

  def self.all
    @@instances
  end

end
