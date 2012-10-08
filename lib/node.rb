class Node
  @@instances = []

  attr_reader :name, :addresses, :links, :routing_table
  attr_accessor :broadcasting

  INFINITY = +1.0/0.0

  def initialize(name, addresses)
    @name = name
    @routing_table = Hash.new
    @addresses = Array(addresses)
    @broadcasting = false
    @addresses.each { |local| @routing_table[local] = ['local',0] }
    @links = []
  end

  def store
    @@instances << self
    self
  end

  def has_link?(node_name)
    @links.include?(node_name)
  end

  def add_link(node_name)
    unless has_link?(node_name)
      @links << node_name
    end
  end

  def remove_link(node_name)
    if has_link?(node_name)
      @links.delete(node_name)
      # "If a link becomes unavailable, set cost to Infinity"
      @routing_table.each do |k, v|
        @routing_table[k] = INFINITY if v.first == node_name
      end
      broadcast_table if @broadcasting
    end
  end

  def broadcast_table
    @links.each do |link|
      send_routing_table(Node.find_by_name(link))
    end
  end

  def parens_table(table_hash)
    table_hash.map { |k, v| "(#{k}|#{v.first}|#{v.last})" }.join(" ")
  end

  def show_table
    puts "table #{@name} #{parens_table(@routing_table)}"
  end

  def send_routing_table(target)
    puts "send #{@name} #{target.name} " + parens_table(@routing_table)
    target.receive_routing_table(@name, @routing_table)
  end

  def receive_routing_table(sender, table)
    puts "receive #{@name} #{sender} " + table.map { |k, v| "(#{k}|#{v.first}|#{v.last})" }.join(" ")
    changes = false

    table.each do |k, v|
      # Ignore information about yourself
      next if k == @name

      update_row = ->(){ (@routing_table[k] = [sender, v.last + 1]) && (changes = true) }

      # "If there is a new destination, add that row to the table"
      if @routing_table[k].nil?
        update_row.call
      # "If there is a lower cost route to an existing node, update the appropriate row"
      elsif (v.last + 1) < @routing_table[k].last
        update_row.call
      # "If the table was recieved on link N, replace all differing rows with N as the link"
      elsif @routing_table[k].first == sender && @routing_table[k].last != (v.last + 1)
        update_row.call
      end
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
