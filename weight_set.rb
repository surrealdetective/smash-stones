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

  def smash(other)
    raise "Weight Set #{self} must be larger than other #{other}" if self.weight < other.weight
    if reduces_to_zero?
      [smash_self, other]
    else
      new_weight = (self.weight - other.weight).abs

      [ 
        WeightSet.new(new_weight, new_weight <= 0 ? 0 : smash_self.num ),
        WeightSet.new(other.weight, other.num - 1 <= 0 ? 0 : other.num - 1 )
      ]
    end
  end

  private
  def smash_self
    if reduces_to_zero?
      WeightSet.new(0, 0)
    else
      WeightSet.new(self.weight, 1)
    end
  end
end

describe 'Weighset#smash' do
  it 'handles single item weight sets' do
    ws1        = WeightSet.new(10,1)
    ws2        = WeightSet.new(9,1)
    nws1, nws2 = ws1.smash(ws2)

    expect([nws1.weight, nws1.num]).to eq [1, 1] 
    expect([nws2.weight, nws2.num]).to eq [9,0]    
  end

  it 'smashes with other weight sets when an even number of larger ws' do
    ws1        = WeightSet.new(10, 10)
    ws2        = WeightSet.new(10, 11)
    nws1, nws2 = ws1.smash(ws2)

    expect([nws1.weight, nws1.num]).to eq [0, 0] 
    expect([nws2.weight, nws2.num]).to eq [10, 11]
  end

  it 'smashes with other weight sets' do
    ws1        = WeightSet.new(10, 11)
    ws2        = WeightSet.new(10, 11)
    nws1, nws2 = ws1.smash(ws2)

    expect([nws1.weight, nws1.num]).to eq [0, 0] 
    expect([nws2.weight, nws2.num]).to eq [10, 10]
  end  

  it 'handles null larger weight' do
    ws1        = WeightSet.new(0,1)
    ws2        = WeightSet.new(0,0)
    nws1, nws2 = ws1.smash(ws2)

    expect([nws1.weight, nws1.num]).to eq [0, 0] 
    expect([nws2.weight, nws2.num]).to eq [0,0]    
  end

  it 'handles identical weight sets smashing together' do
    ws1        = WeightSet.new(10,1)
    ws2        = WeightSet.new(10,1)
    nws1, nws2 = ws1.smash(ws2)

    expect([nws1.weight, nws1.num]).to eq [0, 0] 
    expect([nws2.weight, nws2.num]).to eq [10,0]    
  end  

  it 'handles weight sets of different weights and number' do
    ws1        = WeightSet.new(18,7)
    ws2        = WeightSet.new(10,5)
    nws1, nws2 = ws1.smash(ws2)

    expect([nws1.weight, nws1.num]).to eq [8, 1]
    expect([nws2.weight, nws2.num]).to eq [10,4]    
  end    
end

describe 'WeightSet#reduces_to_zero?' do
  it 'returns true if number is even' do
    ws = WeightSet.new(5,2)
    expect(ws.reduces_to_zero?).to eq true
  end

  it 'returns false if number is odd' do
    ws = WeightSet.new(8,1)
    expect(ws.reduces_to_zero?).to eq false    
  end
end