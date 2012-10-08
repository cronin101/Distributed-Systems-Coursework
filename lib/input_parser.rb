class InputParser

  def self.parse_file(filename)
    file = File.open(filename)
    file.readlines.map { |line| parse_line(line) }
  end

  def self.parse_line(line)
      matches = line.scan /\w+/
      object_type = matches.shift

      case object_type

      when 'node'
        name = matches.shift
        addresses = matches
        Node.new(name, addresses).store

      when 'link'
        endpoints = matches.take(2)
        Link.new(endpoints).store

      when 'send'
        target = matches.first
        NodeCommand.new(target, :send).enqueue
      end
  end

end
