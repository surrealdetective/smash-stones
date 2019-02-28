def lastStoneWeight(weights)
  queue = StoneSmashingQueue.new(weights)
  queue.reduce
  queue.largest_weight
end

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
    raise "Weight Set must be larger than other" if self.weight < other.weight
    new_weight = (self.weight - other.weight).abs
    [ 
      WeightSet.new(new_weight, new_weight == 0 ? 0 : 1 ),
      WeightSet.new(other.weight, other.num - 1)
    ]
  end
end

class NullSmashResults
  attr_reader :new_weight_set, :smaller_weight_set, :store
  def initialize
    @new_weight_set     ||= WeightSet.new(0,0)
    @smaller_weight_set ||= WeightSet.new(0,0)
    @store              ||= {}
  end
end

SmashResults = Struct.new(:new_weight_set, :smaller_weight_set, :store)

class StoneSmashingQueue
  attr_accessor :store, :largest_weight, :second_largest_weight

  def initialize(weights)
    @store ||= _store_as_hash(Array(weights))
  end

  def reduce
    while has_stones_to_smash?
      update_queue!(
        StoneSmasher.smash_weight_sets(
          weight_set(self.largest_weight), 
          weight_set(self.second_largest_weight), 
          self.store
        )
      )
    end
  end

  def has_stones_to_smash?
    has_stones_of_different_weights? || !(has_one_stone? || has_zero_stones?)
  end

  def has_stones_of_different_weights?
    store.count > 1
  end

  def has_one_stone?
    store.count == 1 && store.values.sum == 1
  end

  def has_zero_stones?
    store.count == 0 && store.values.sum == 0
  end

  private
  def weight_set(weight)
    WeightSet.new(weight, store[weight.to_s])
  end

  def _store_as_hash(weights)
    Hash.new(0).tap do |store|
      weights.sort.reverse.each_with_index do |weight, index|
        store[weight.to_i.to_s] += 1
        @largest_weight          = weight if index == 0
        @second_largest_weight   = weight if index > 0 && weight < largest_weight.to_f && second_largest_weight.nil?
      end
    end
  end

  def update_queue!(smash_results)
    self.store = smash_results.store
    if has_stones_to_smash?
      find_largest_weight!
    elsif has_one_stone?
      self.largest_weight = store.first.first.to_i
    else
      self.largest_weight = smash_results.new_weight_set.weight
    end
    find_second_largest_weight!
  end

  def find_largest_weight!
    raise "Largest weight must already be smashed with store #{store}" if has_weight?(self.largest_weight)
    while !has_weight?(self.largest_weight)
      self.largest_weight = self.largest_weight - 1
    end
  end
  
  def find_second_largest_weight!
    if has_stones_of_different_weights?
      self.second_largest_weight = self.largest_weight - 1
      while !has_weight?(self.second_largest_weight)
        self.second_largest_weight = self.second_largest_weight - 1
      end
    else
      self.second_largest_weight = 0
    end
  end
  
  def has_weight?(weight)
    store[weight.to_s] > 0
  end
end

class StoneSmasher
  def self.smash_weight_sets(larger_ws, second_lws, store)
    if larger_ws.reduces_to_zero?
      self._remove_larger_weight_set(larger_ws, second_lws, store)  
    else
      self._smash_larger_weight_set_w_one_count_from_other_weight_set(
        larger_ws, 
        second_lws,
        store
      )
    end
  end

  def self._remove_larger_weight_set(larger_ws, second_lws, store)
    self._remove_weightset_from_store(larger_ws, store)
    # store.delete(larger_ws.to_s)
    new_ws     = WeightSet.new(0,0)
    smaller_ws = second_lws
    SmashResults.new(new_ws, smaller_ws, store)
  end

  def self._smash_larger_weight_set_w_one_count_from_other_weight_set(larger_ws, other_ws, store)
    reduced_to_one_ws    = larger_ws.smash_self
    new_ws, new_other_ws = reduced_to_one_ws.smash(other_ws)
    self._remove_weightset_from_store(larger_ws, store)
    self._update_other_ws(new_other_ws, store)
    self._update_new_ws(new_ws, store)
    SmashResults.new(new_ws, new_other_ws, store)
  end

  def self._remove_weightset_from_store(weightset, store)
    store.delete(weightset.to_s)
  end

  def self._update_other_ws(new_other_ws, store)
    store[new_other_ws.to_s] = new_other_ws.num
    self._remove_weightset_from_store(new_other_ws, store) if store[new_other_ws.to_s] <= 0    
  end

  def self._update_new_ws(new_ws, store)
    store[new_ws.to_s] += new_ws.num
    store.delete(new_ws.to_s) if store[new_ws.to_s] <= 0
  end
end

describe '#has_stones_to_smash?' do
  it 'is false with 0 stones' do
    queue = StoneSmashingQueue.new([])
    expect(queue.has_stones_to_smash?).to eq false
  end 

  it 'is false with 1 stone' do
    queue = StoneSmashingQueue.new([1])
    expect(queue.has_stones_to_smash?).to eq false
  end 

  it 'is true with 2 diff weighted stones' do
    queue = StoneSmashingQueue.new([1, 2])
    expect(queue.has_stones_to_smash?).to eq true
  end

  it 'is true with 2 same-weighted stones' do
    queue = StoneSmashingQueue.new([1, 1])
    expect(queue.has_stones_to_smash?).to eq true
  end  
end

describe '#lastStoneWeight(weights)' do
  it 'finds difference between 2 weights' do
    expect(lastStoneWeight([10, 9])).to eq 1
    expect(lastStoneWeight([100, 9])).to eq 91
  end 

  it 'smashes even identical stones to 0' do
    expect(lastStoneWeight([10, 10])).to eq 0
    expect(lastStoneWeight([10, 10, 10, 10])).to eq 0
  end 

  it 'smashes odd identical stones' do
    expect(lastStoneWeight([10])).to eq 10
    expect(lastStoneWeight([10, 10, 10])).to eq 10
    expect(lastStoneWeight([10, 10, 10, 10, 10])).to eq 10
  end

  it 'smashes even identical stones and finds difference btwn 2 weights' do
    expect(lastStoneWeight([10, 10, 9, 8])).to eq 1
  end      

  it 'smashes multiple sets of even identical stones' do
    expect(lastStoneWeight([10, 10, 9, 9])).to eq 0
  end

  it 'smashes odd identical stones and even identical stones in random order' do
    expect(lastStoneWeight([10, 8, 9, 10, 8, 10, 10, 10].shuffle)).to eq 1
  end

  it 'smashes odd identical stones' do
    expect(lastStoneWeight([10, 8, 9, 10, 8, 10, 10, 10, 1, 1, 1, 1, 1, 1].shuffle)).to eq 1
  end

  it 'returns 0' do
    expect(lastStoneWeight([1, 10, 8, 1, 1, 9, 10, 8, 10, 10, 10, 1, 1])).to eq 0
  end    

  it 'returns 1' do
    expect(lastStoneWeight([1, 10, 8, 1, 1, 9, 10, 8, 10, 10, 10, 1, 1, 1])).to eq 1
  end  
  
  it 'smashes increasingly smaller items' do
    expect(lastStoneWeight([200, 150, 100, 50, 25, 10])).to eq 15
  end    

  it 'smashes a series' do
    expect(lastStoneWeight([10, 9, 8 , 7, 6, 5, 4, 3, 2, 1])).to eq 1
  end

  it "handles large numbers slowly" do
    expect(lastStoneWeight([1000000, 100000, 10000, 1000, 100, 10, 1])).to eq 888889
  end  
end