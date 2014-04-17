class NodeCommand
  attr_reader :target, :action
  @@queue = []

  def initialize(target, action)
    @target = target
    @action = action
  end

  def enqueue
    @@queue << self
  end

  def self.trigger_actions
    @@queue.each do |job|
      Node.find_by_name(job.target).send(:broadcast_table) if job.action == :send
      @@queue.delete(job)
    end
  end
end
