module BinarySearchPlus
  def conditional_binary_search_insert_and_sort(array, look_for)
    # Edge Cases
    return array.insert(0, look_for) if array.empty? && !look_for.nil?
    return array.insert(0, look_for) if array.length == 1 && look_for < array.first
    return array if array.length == 1 && look_for == array.first
    return array.insert(1, look_for) if array.length == 1 && look_for > array.first
    
    # Binary Search
    min = 0
    max = array.length - 1
    middle = (min + max)/2
    while min <= max && max - min > 1
      middle = (min + max)/2
      if array[middle] == look_for
        return array
      else
        array[middle] < look_for ? min=middle : max=middle
      end
    end
    
    # Insert item in correct spot
    if look_for == array[min] || look_for == array[max]
      return array
    elsif look_for < array[min]
      return array.insert(min, look_for)
    elsif look_for < array[max]
      return array.insert(max, look_for)
    elsif look_for > array[max]
      return array.insert(max+1, look_for)
    end
  end
end

class BinarySearch
  extend BinarySearchPlus
end

describe 'Binary Search Plus#conditional_binary_search_insert_and_sort' do
  it 'add things in a big pre-sorted array' do
    expect(
      BinarySearch.conditional_binary_search_insert_and_sort([0, 1, 2, 3, 5, 6, 7, 8, 9], 4)
    ).to eq [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
  end

  it 'add things in an empty array' do
    expect(
      BinarySearch.conditional_binary_search_insert_and_sort([], 1)
    ).to eq [1]
  end  

  it 'add things in a 1-item array unless item already exists' do
    expect(
      BinarySearch.conditional_binary_search_insert_and_sort([2], 1)
    ).to eq [1, 2]

    expect(
      BinarySearch.conditional_binary_search_insert_and_sort([2], 3)
    ).to eq [2, 3]  

    expect(
      BinarySearch.conditional_binary_search_insert_and_sort([2], 2)
    ).to eq [2]
  end    

  it 'add things in a 2-item pre-sorted array unless item already exists' do
    expect(
      BinarySearch.conditional_binary_search_insert_and_sort([2, 4], 1)
    ).to eq [1, 2, 4]

    expect(
      BinarySearch.conditional_binary_search_insert_and_sort([2, 4], 2)
    ).to eq [2, 4]

    expect(
      BinarySearch.conditional_binary_search_insert_and_sort([2, 4], 3)
    ).to eq [2, 3, 4]

    expect(
      BinarySearch.conditional_binary_search_insert_and_sort([2, 4], 4)
    ).to eq [2, 4]

    expect(
      BinarySearch.conditional_binary_search_insert_and_sort([2, 4], 5)
    ).to eq [2, 4, 5]
  end      

  it 'add things in a 3-item pre-sorted array unless item already exists' do
    expect(
      BinarySearch.conditional_binary_search_insert_and_sort([2, 4, 6], 1)
    ).to eq [1, 2, 4, 6]

    expect(
      BinarySearch.conditional_binary_search_insert_and_sort([2, 4, 6], 2)
    ).to eq [2, 4, 6]

    expect(
      BinarySearch.conditional_binary_search_insert_and_sort([2, 4, 6], 3)
    ).to eq [2, 3, 4, 6]

    expect(
      BinarySearch.conditional_binary_search_insert_and_sort([2, 4, 6], 4)
    ).to eq [2, 4, 6]

    expect(
      BinarySearch.conditional_binary_search_insert_and_sort([2, 4, 6], 5)
    ).to eq [2, 4, 5, 6]

    expect(
      BinarySearch.conditional_binary_search_insert_and_sort([2, 4, 6], 6)
    ).to eq [2, 4, 6]

    expect(
      BinarySearch.conditional_binary_search_insert_and_sort([2, 4, 6], 7)
    ).to eq [2, 4, 6, 7]
  end  

  it 'handles insertion in a bigger pre-sorted array' do
    expect(
      BinarySearch.conditional_binary_search_insert_and_sort(
        [1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 27, 29, 100000, 100000000],
        18
      )
    ).to eq [1, 3, 5, 7, 9, 11, 13, 15, 17, 18, 19, 21, 23, 25, 27, 29, 100000, 100000000]

    expect(
      BinarySearch.conditional_binary_search_insert_and_sort(
        [1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 27, 29, 100000, 100000000],
        18
      )
    ).to eq [1, 3, 5, 7, 9, 11, 13, 15, 17, 18, 19, 21, 23, 25, 27, 29, 100000, 100000000]

    expect(
      BinarySearch.conditional_binary_search_insert_and_sort(
        [1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 27, 29, 100000, 100000000],
        321321
      )
    ).to eq [1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 27, 29, 100000, 321321, 100000000]

    expect(
      BinarySearch.conditional_binary_search_insert_and_sort(
        [1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 27, 29, 100000, 100000000],
        321321321
      )
    ).to eq [1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 27, 29, 100000, 100000000, 321321321]
  end  
end