class NodeCommand
  @@queue = []

  attr_reader :target, :action

  def initialize(target, action)
    @target = target
    @action = action
  end

  def enqueue
    @@queue << self
  end

  def inspect
    puts "<#{self.class}> { target: #{@target}, action: #{@action} }"
  end

  def self.queue
    @@queue
  end

  def self.trigger_actions
    queue.each do |job|
      if job.action == :send
        Node.find_by_name(job.target).broadcast_table
        queue.delete(job)
      end
    end
  end

end
