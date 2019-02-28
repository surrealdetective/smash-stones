require 'rspec/autorun'

def lastStoneWeight(weights)
  WeightStorage.new(weights).reduce
end

class WeightSet
  attr_reader :weight, :num

  def initialize(weight, num)
    @weight = weight.to_f
    @num    = num.to_i
  end

  def +(other)
    new_weight = (self.to_f - other.to_f).abs
    WeightSet.new(new_weight, new_weight == 0 ? 0 : 1 )
  end

  def to_f
    if num % 2 == 0
      0
    else
      self.weight
    end
  end

  def to_s
    self.weight.to_s
  end
end

class WeightStorage
  attr_reader :store

  def initialize(weights)
    @store ||= format(weights)
  end

  def reduce
    while store.count > 1 && store.values.sum != 1
      weight_sets = shift(2)
      new_weight_set  = weight_sets.inject(:+)
      update_weights(new_weight_set) if new_weight_set.to_f > 0
    end
    return store.count == 0 ? 0 : WeightSet.new(*store.to_a.first).weight
  end

  private

  def update_weights(weight_set)
    store[weight_set.to_s] += 1
  end

  def shift(num)
    store.first(num).map do |weight_num_arr| 
      store.delete(weight_num_arr.first.to_s)
      WeightSet.new(*weight_num_arr)
    end
  end

  def format(weights)
    Hash.new(0).tap do |store|
      weights.sort.reverse.each do |weight|
        store[weight.to_f.to_s] += 1
      end
    end
  end
end


describe '#lastStoneWeight(weights)' do
  it 'finds difference between 2 weights' do
    expect(lastStoneWeight([10, 9])).to eq 1
  end

  it 'returns 0' do
    expect(lastStoneWeight([1, 10, 8, 1, 1, 9, 10, 8, 10, 10, 10, 1, 1])).to eq 0
  end    

  it 'returns 1' do
    expect(lastStoneWeight([1, 10, 8, 1, 1, 9, 10, 8, 10, 10, 10, 1, 1, 1])).to eq 1
  end

  it 'returns a large number' do
    expect(lastStoneWeight([1, 10, 10**10, 10**10, 10**10])).to eq (10**10) - 10 - 1
  end 
end
