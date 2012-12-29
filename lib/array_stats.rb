#monkey path methods for stats into Array
# all calcs forced to float for our purposes
class Array
  def sum
    self.inject(:+).to_f
  end

  def mean
    return 0.0 if self.length < 1
    self.sum / self.length.to_f
  end

  def sample_standard_deviation
    #unless we have at least 2 items in list, std dev is 0 by convention
    return 0.0 if self.length < 2
    
    mean = self.mean
    sum = self.inject(0.0) { |acc, i| acc + ((i - mean)**2) }
    
    Math.sqrt( sum / (self.length - 1))
  end

end

#run unit tests by running this file directly
if $0==__FILE__
  puts "Running unit tests"
  require 'test/unit'

  class ArrayStatsTests < Test::Unit::TestCase

    #special case tests, empty array and array with single element

    AR_EMPTY = []
    AR_SINGLE = [123.456]

    def test_empty_array_stats
      assert_equal(0.0, AR_EMPTY.sum)
      assert_equal(0.0, AR_EMPTY.mean)
      assert_equal(0.0, AR_EMPTY.sample_standard_deviation)
    end

    def test_single_array_stats
      assert_equal(123.456, AR_SINGLE.sum)
      assert_equal(123.456, AR_SINGLE.mean)
      assert_equal(0.0, AR_SINGLE.sample_standard_deviation)
    end

    #simple cases
     
    AR_SIMPLE = [1.2, 3.4]

    def test_simple_case
      assert_equal(4.6, AR_SIMPLE.sum)
      assert_equal(2.3, AR_SIMPLE.mean)
      assert_in_delta(1.56, AR_SIMPLE.sample_standard_deviation, 0.01)
    end

   AR1 = [0.0, 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0]

    def test_ten_case
      assert_equal(45.0, AR1.sum)
      assert_equal(4.5, AR1.mean)
      assert_in_delta(3.03, AR1.sample_standard_deviation, 0.01)
    end

  end
end
