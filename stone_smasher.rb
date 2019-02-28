require 'forwardable'
require './binary_search_plus.rb'

class StoneSmasher
  extend Forwardable
  include BinarySearchPlus

  attr_accessor :larger_ws, :second_lws
  def_delegators :weight_store_tracker, :store, :smashed_store, :largest_weight, :second_largest_weight
  attr_reader :weight_store_tracker

  def initialize(args={})
    @weight_store_tracker = args[:weight_store_tracker]
    @larger_ws            = weight_set(largest_weight)
    @second_lws           = weight_set(second_largest_weight)
  end

  def smash_weight_sets
    weight_store_tracker.tap do |wst|
      if larger_ws.reduces_to_zero?
        remove_largest_weightset_from_store!(larger_ws)
      else
        smash_larger_weight_set_w_one_count_from_other_weight_set!(
          larger_ws,
          second_lws
        )
      end
    end
  end

  private
  # Init Objects
  def weight_set(weight)
    WeightSet.new(weight, store[weight.to_s])
  end

  # Store and Weight Counting
  def_delegators :weight_store_tracker, :smashed_store_has_largest?, :has_weight?

  # Update Store
  def remove_largest_weightset_from_store!(weightset)
    raise "Must remove largest weight #{largest_weight} vs. weightset #{weightset}" if largest_weight != weightset.weight
    store.delete(weightset.to_s)
    smashed_store.pop if smashed_store_has_largest?
  end

  def smash_larger_weight_set_w_one_count_from_other_weight_set!(larger_ws, other_ws)
    reduced_to_one_ws    = larger_ws.smash_self
    new_ws, new_other_ws = reduced_to_one_ws.smash(other_ws)

    remove_largest_weightset_from_store!(larger_ws)
    update_other_ws!(new_other_ws)
    update_new_ws!(new_ws)
  end

  def update_other_ws!(new_other_ws)
    store[new_other_ws.to_s] = new_other_ws.num
    remove_weightset_from_store_if_nil!(new_other_ws)
  end

  def update_new_ws!(new_ws)
    conditional_binary_search_insert_and_sort(smashed_store, new_ws.weight) if !has_weight?(new_ws)

    store[new_ws.to_s] += new_ws.num
    remove_weightset_from_store_if_nil!(new_ws)
  end

  def remove_weightset_from_store_if_nil!(weightset)
    store.delete(weightset.to_s) if !has_weight?(weightset)
  end  
end