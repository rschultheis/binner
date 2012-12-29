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

  def standard_deviation
    #unless we have at least 2 items in list, std dev is 0 by convention
    return 0.0 if self.length < 2
    
    mean = self.mean
    sum = self.inject(0.0) { |acc, i| acc + ((i - mean)**2) }
    
    Math.sqrt( sum / (self.length - 1))
  end

end
