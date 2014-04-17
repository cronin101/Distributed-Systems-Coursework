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
    @@instances.each do |link|
      e1, e2 = link.endpoints.take(2)
      Node.find_by_name(e1).add_link(e2)
      Node.find_by_name(e2).add_link(e1)
    end
  end
end
