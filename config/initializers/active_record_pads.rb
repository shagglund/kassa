module ActiveRecord
  class Base

    def save_without_timestamps!
      class << self
        def record_timestamps; false; end
      end

      save!

      class << self
        remove_method :record_timestamps
      end
    end

    def save_without_timestamps
      class << self
        def record_timestamps; false; end
      end

      result = save

      class << self
        remove_method :record_timestamps
      end
      result
    end

    def self.acts_as_actionable
      include Actionable
    end
  end
end