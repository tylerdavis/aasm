class Gate < ActiveRecord::Base
  include AASM

  # Fake this column for testing purposes
  attr_accessor :aasm_state

  aasm do
    state :opened
    state :closed

    event :view do
      transitions :to => :read, :from => [:needs_attention]
    end
  end
end

class Reader < ActiveRecord::Base
  def aasm_read_state
    "fi"
  end
  include AASM
end

class Writer < ActiveRecord::Base
  def aasm_write_state(state)
    "fo"
  end
  include AASM
end

class Transient < ActiveRecord::Base
  def aasm_write_state_without_persistence(state)
    "fum"
  end
  include AASM
end

class Simple < ActiveRecord::Base
  include AASM
  aasm_column :status
  aasm_state :unknown_scope
  aasm_state :new
end

class SimpleNewDsl < ActiveRecord::Base
  include AASM
  aasm :column => :status
  aasm do
    state :unknown_scope
    state :new
  end
end

class Derivate < Simple
end

class DerivateNewDsl < SimpleNewDsl
end

class Thief < ActiveRecord::Base
  if ActiveRecord::VERSION::MAJOR >= 3
    self.table_name = 'thieves'
  else
    set_table_name "thieves"
  end
  include AASM
  aasm_initial_state  Proc.new { |thief| thief.skilled ? :rich : :jailed }
  aasm_state          :rich
  aasm_state          :jailed
  attr_accessor :skilled, :aasm_state
end
