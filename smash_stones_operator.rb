require 'forwardable'

class SmashStonesOperator
  extend Forwardable
  def_delegators :weight_store_tracker, :store, :largest_weight, :second_largest_weight
  attr_accessor :weight_store_tracker

  def initialize(weights)
    @weight_store_tracker = WeightStoreTracker.new({weights: Array(weights)})
  end

  def reduce
    while has_stones_to_smash?
      update_store_and_weights!(
        StoneSmasher.new(stone_smasher_args).smash_weight_sets
      )
    end
  end

  def has_stones_to_smash?
    has_stones_of_different_weights? || has_multiple_stones?
  end

  private
  # Stone Counting
  def has_stones_of_different_weights?
    store.count > 1
  end

  def has_multiple_stones?
    !(has_one_stone? || has_zero_stones?)
  end

  def has_one_stone?
    store.count == 1 && store.values.sum == 1
  end

  def has_zero_stones?
    store.count == 0 && store.values.sum == 0
  end

  def stone_smasher_args
    {
      weight_store_tracker: weight_store_tracker,
    }
  end

  # Update Store and Weights
  def update_store_and_weights!(stone_smasher_weight_store_tracker)
    self.weight_store_tracker = stone_smasher_weight_store_tracker
    weight_store_tracker.update_store_and_weights!
  end
end

describe 'StoneSmashOperator#has_stones_to_smash?' do
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