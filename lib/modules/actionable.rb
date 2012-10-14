module Actionable
  def self.included(base)
    base.send :attr_accessor, :action_by
    base.send :attr_accessible, :action_by
    base.send :validates, :action_by, :presence => true
  end
end