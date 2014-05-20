class LimitedValuePicker
  attr_reader :min, :max, :default
  def initialize(opts)
    @max, @min, @default = opts.values_at(:max, :min, :default)
  end

  def get(value)
    value ||= default
    return if value.nil?
    return max if max && value > max
    return min if min && value < min
    value
  end
end