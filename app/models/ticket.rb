class Ticket < ActiveRecord::Base
  
  belongs_to :project
  has_one :ticket_queue, conditions: "destroyed_at IS NULL"
  has_many :testing_notes
  
  default_scope includes(:ticket_queue)
  
  validates :project_id, presence: true
  validates :summary, presence: true
  validates :number, presence: true
  validates_uniqueness_of :number, :scope => :project_id
  
  
  class << self
    def in_queue(queue)
      queue = queue.slug if queue.is_a?(KanbanQueue)
      where(["ticket_queues.queue = ?", queue])
    end
    
    def numbered(*numbers)
      numbers = numbers.flatten.map(&:to_i)
      where(:number => numbers)
    end
    
    def attributes_from_unfuddle_ticket(unfuddle_ticket)
      unfuddle_ticket.pick("number", "summary", "description")
    end
  end
  
  
  def set_queue!(value)
    return if queue == value
    
    Ticket.transaction do
      ticket_queue.destroy if ticket_queue
      create_ticket_queue!(ticket: self, queue: value)
    end
    
    value
  end
  alias :queue= :set_queue!
  
  def queue
    ticket_queue && ticket_queue.name
  end
  
  # Returns the amount of time the ticket has spent in its current queue (in seconds)
  def age
    ticket_queue ? ticket_queue.queue_time : 0
  end
  
  
  
  def testers
    project.testers
  end
  
  def verdicts
    # !todo: get the most recent verdict per tester; only the ones since the last deploy
    testing_notes.map(&:verdict)
  end
  
  def testing_status
    if verdicts.member? "fails"
      "failing"
    elsif verdicts.length < testers.length
      "pending"
    else
      "passing"
    end
  end
  
  
end
