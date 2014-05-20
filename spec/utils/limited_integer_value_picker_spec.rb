require 'spec_helper'

describe LimitedIntegerValuePicker do
  let(:min){5}
  let(:default){10}
  let(:max){20}
  subject{described_class.new(default: default, min: min, max: max)}
  describe "#initalize" do
    def check_initialized_values(key, first_value, second_value)
      expect(described_class.new(key => first_value).send(key)).to eq(first_value)
      expect(described_class.new(key => second_value).send(key)).to eq(second_value)
    end
    it "should pick maximum value from args" do
      check_initialized_values :max, 1, 2
    end
    it "should pick minimum value from args" do
      check_initialized_values :min, 1, 2
    end

    it "should pick default value from args" do
      check_initialized_values :default, 1, 2
    end
  end

  describe "#get" do
    it "should return the default if passed in value is nil" do
      expect(subject.get(nil)).to eq(default)
    end

    it "should return max if value > max" do
      expect(subject.get(max+1)).to eq(max)
    end

    it "should return min if value < min" do
      expect(subject.get(min-1)).to eq(min)
    end

    it "should return value if min < value < max" do
      expect(subject.get(min + 1)).to eq(min+1)
    end
  end
end