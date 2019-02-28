# README
This is a coding problem that I solved. See below for the coding problem description.

## Coding Problem Description
You are a given a set of stones, each of which has a weight, like 3 lbs or 7 lbs. 

You will now smash the stones together from biggest to smallest such that you take 2 stones and smash them. 

Continue until there is only 1 stone left. 

Determine what the weight of the last stone is given the following conditions:

1. Always smash the biggest 2 stones together.

2. If the you smash a bigger stone with a smaller stone, then you get a stone that is the difference in weight: a 7 lb. and 3 lb. stone smashed together creates a 4 lb. stone. 

3. If you smash stones that are the same weight, then both stones are obliterated. For example, smash two 4 lb. stones and you get 0 remaining stones.

4. Assume that the stones you are given are not sorted by weight.

5. Find the last stone weight with method lastStoneWeight(weights)

## Example Scenario 1
* You have 5 stones of the following weights: [3, 4, 4, 7, 1]
* First we'll smash 7 & 4 stones, which leads to [3, 4, 3, 1]
* Next we'll smash 4 & 3 stones, which leads to [1, 3, 1]
* Next we'll smash 3 & 1 stones, which leads to [2, 1]
* Finally we'll smash 2 & 1 stones, which leads to [1]

The weight of the last stone after all stones are smashed together is 1.

## Example Scenario 2
* You have 5 stones of the following weights: [10, 10, 5, 1, 1]
* First smash 10 and 10: [5, 1, 1]
* Next smash 5 and 1: [4, 1]
* Finally smash 4 and 1: [3]

The weight of the last stone is 3.

## How to Run Tests
Tests are located in 5 files currently:
* lastStoneWeight.rb
* binary_search_plus.rb
* smash_stones_operator.rb
* weight_store_tracker.rb
* weight_set.rb

You can run the tests with: 
* `rspec lastStoneWeight.rb`
* `rspec binary_search_plus.rb`
* `rspec smash_stones_operator.rb`
* `rspec weight_store_tracker.rb`
* `rspec weight_set.rb`

Please note that because all files are required in lastStoneWeight.rb, you can run all tests with simply `rspec lastStoneWeight.rb`.