require 'lib/excel'

#configuration
BinSize = 0.1
ErrorSize = 0.01
MinBin = 0.5
MaxBin = 4.0


#read and sort the data
input_filename = ARGV[0]
#get the data out of the excel file
data = ExcelIO.read_length_data(input_filename)
#sort the data
data.sort!
puts "read '#{data.length}' values out of '#{input_filename}"
puts "min: #{data.first}"
puts "max: #{data.last}"
puts ''


#put data into bins
bins = {}
curBin = MinBin
data_idx = 0
while (curBin <= MaxBin)
  binMax = curBin + BinSize
  bin = []
 
  while ((data_idx < data.length) && (data[data_idx] < binMax))
    bin << data[data_idx]
    data_idx += 1
  end
  
  bin_label = "#{"%0.2f" % curBin}-#{"%0.2f" % (binMax - ErrorSize)}" 
  bins[bin_label] = bin
  curBin += BinSize
end

bins.keys.sort.each do |key|
  puts key.to_s + ': ' + bins[key].length.to_s
end




