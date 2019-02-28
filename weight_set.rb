class WeightSet
  attr_reader :weight, :num

  def initialize(weight, num)
    @weight = weight.to_i
    @num    = num.to_i
  end

  def reduces_to_zero?
    num % 2 == 0
  end

  def to_s
    self.weight.to_s
  end

  def smash_self
    if reduces_to_zero?
      WeightSet.new(0, 0)
    else
      WeightSet.new(self.weight, 1)
    end
  end

  def smash(other)
    # raise "Weight Set #{self} must be larger than other #{other}" if self.weight < other.weight
    new_weight = (self.weight - other.weight).abs
    [ 
      WeightSet.new(new_weight, new_weight == 0 ? 0 : 1 ),
      WeightSet.new(other.weight, other.num - 1)
    ]
  end
end