class InputParser
  def self.parse_file(filename)
    File.open(filename).readlines.each(&parse_line)
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
