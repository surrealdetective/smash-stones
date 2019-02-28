class WeightStoreTracker
  attr_accessor :store, :largest_weight, :second_largest_weight, :smashed_store

  def initialize(args={})
    @store         ||= _store_as_hash(args.fetch(:weights, []))
    @smashed_store ||= args.fetch(:smashed_store, [])
    update_store_and_weights!

  end

  def update_store_and_weights!(store=self.store, smashed_store=self.smashed_store)
    self.store                 = store
    self.smashed_store         = smashed_store
    self.largest_weight        = find_largest_weight
    self.second_largest_weight = find_second_largest_weight
  end

  private
  # Store Counting
  def smashed_store_has_largest?
    largest_weight == smashed_store.last
  end

  def has_weight?(weight)
    store[weight.to_s] > 0
  end    

  # Init Objects
  def _store_as_hash(weights)
    Hash.new(0).tap do |store|
      weights.sort.reverse.each_with_index do |weight, index|
        store[weight.to_i.to_s] += 1
      end
    end
  end

  # Find Weights
  def find_largest_weight
    largest_smashed_store_weight >= largest_store_weight ? 
      largest_smashed_store_weight : largest_store_weight
  end

  def find_second_largest_weight
    if smashed_store_has_largest? #does this handle 0 case? if smashed_store_has_largest? #does this handle 0 case? 
      second_largest_smashed_store_weight >= largest_store_weight ? 
        second_largest_smashed_store_weight : largest_store_weight
    else
      largest_smashed_store_weight >= second_largest_store_weight ? 
        largest_smashed_store_weight : second_largest_store_weight
    end
  end

  # Store Weights
  def largest_store_weight
    if store.any?
      weight_count_pair = store.first
      weight_count_pair.first.to_i
    else
      0
    end
  end

  def second_largest_store_weight
    first_two = store.first(2)
    if first_two.count == 2
      weight_count_pair = first_two.last
      weight_count_pair.first.to_i
    else
      0
    end
  end

  # Smashed Store Weights
  def largest_smashed_store_weight
    smashed_store[-1].to_i
  end

  def second_largest_smashed_store_weight
    smashed_store[-2].to_i
  end

end