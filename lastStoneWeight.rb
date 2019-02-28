require './weight_store_tracker.rb'
require './smash_results.rb'
require './stone_smasher.rb'
require './smash_stones_operator.rb'
require './weight_set.rb'

def lastStoneWeight(weights)
  operator = SmashStonesOperator.new(weights)
  operator.reduce
  operator.largest_weight
end

describe 'WeightStoreTracker' do
  it 'initializes and finds largest weights with empty array' do
    wst = WeightStoreTracker.new(weights: [])
    expect(wst.largest_weight).to eq 0
    expect(wst.second_largest_weight).to eq 0
  end

  it 'initializes and finds largest weights with 1 weight' do
    wst = WeightStoreTracker.new(weights: [10])
    expect(wst.largest_weight).to eq 10
    expect(wst.second_largest_weight).to eq 0
  end  

  it 'initializes and finds largest weights with 2 identical weight' do
    wst = WeightStoreTracker.new(weights: [10, 10])
    expect(wst.largest_weight).to eq 10
    expect(wst.second_largest_weight).to eq 0
  end  

  it 'initializes and finds largest weights with 2 diff weights' do
    wst = WeightStoreTracker.new(weights: [10, 9])
    expect(wst.largest_weight).to eq 10
    expect(wst.second_largest_weight).to eq 9
  end  

  it 'initializes and finds largest weights with 2 identical largest weights and other weights' do
    wst = WeightStoreTracker.new(weights: [10, 10, 9, 8])
    expect(wst.largest_weight).to eq 10
    expect(wst.second_largest_weight).to eq 9
  end    
end

describe '#has_stones_to_smash?' do
  it 'is false with 0 stones' do
    operator = SmashStonesOperator.new([])
    expect(operator.has_stones_to_smash?).to eq false
  end 

  it 'is false with 1 stone' do
    operator = SmashStonesOperator.new([1])
    expect(operator.has_stones_to_smash?).to eq false
  end 

  it 'is true with 2 diff weighted stones' do
    operator = SmashStonesOperator.new([1, 2])
    expect(operator.has_stones_to_smash?).to eq true
  end

  it 'is true with 2 same-weighted stones' do
    operator = SmashStonesOperator.new([1, 1])
    expect(operator.has_stones_to_smash?).to eq true
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

  it 'handles large numbers' do
    expect(lastStoneWeight([100000000, 2, 1])).to eq 99999997
  end

  it "handles smaller numbers on the way to large numbers" do
    expect(lastStoneWeight([10, 1])).to eq 9
    expect(lastStoneWeight([100, 10, 1])).to eq 89
    expect(lastStoneWeight([1000, 100, 10, 1])).to eq 889
    expect(lastStoneWeight([10000, 1000, 100, 10, 1])).to eq 8889
  end

  it "handles large numbers" do
    expect(lastStoneWeight([1000000000, 100000000, 10000000, 1000000, 100000, 10000, 1000, 100, 10, 1])).to eq 888888889
  end

  it 'processes 10k stones under 1 second' do
    expect(lastStoneWeight((1..(10**4)).to_a)).to be_kind_of(Integer)
  end
end