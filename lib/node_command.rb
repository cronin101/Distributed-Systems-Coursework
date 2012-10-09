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

  def self.trigger_actions
    @@queue.each do |job|
      Node.find_by_name(job.target).broadcast_table if job.action == :send
      @@queue.delete(job)
    end
  end

end
