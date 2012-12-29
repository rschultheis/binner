require 'lib/excel'
require 'lib/array_stats'

#configuration
BinSize = 0.1
MinBin = 0.3
MaxBin = 4.0


#read and sort the data
data = {}
data[:input_filename] = ARGV[0]

#get the data out of the excel file
data[:raw] = ExcelIO.read_length_data(data[:input_filename])
data[:length] = data[:raw].length

#sort the data
data[:sorted] = data[:raw].sort

#basic stats
data[:min] = data[:sorted].first
data[:max] = data[:sorted].last

#output input summary
puts "read '#{data[:length]}' values out of '#{data[:input_filename]}'"
puts "min: #{data[:min]}"
puts "max: #{data[:max]}"
puts ''


#put data into bins
data[:bins] = {}
curBin = MinBin
data_idx = 0
while (curBin <= MaxBin)
  binMax = curBin + BinSize
  values = []
 
  while ((data_idx < data[:length]) && (data[:sorted][data_idx] < binMax))
    values << data[:sorted][data_idx]
    data_idx += 1
  end
  
  bin_label = "#{"%0.2f" % curBin} -> #{"%0.2f" % binMax}" 
  data[:bins][bin_label] = { :values => values }
  curBin += BinSize
end


#process the bins
data[:bins].each_pair do |bin_label, bin|
  bin[:length] = bin[:values].length
  #calculate the frequency
  bin[:frequency] = bin[:length].to_f / data[:length].to_f
  #standard deviation
  bin[:standard_deviation] = bin[:values].standard_deviation
  #standard_error
  bin[:standard_error] = bin[:standard_deviation] / Math.sqrt(data[:length])
end

#output the bins

#output_filename = 'output.xls'
data[:output_filename] = 'processed_' + File.basename(data[:input_filename]).gsub(/\s/,'_').downcase
ExcelIO.write_bin_file data, data[:output_filename]

puts "output written to '#{data[:output_filename]}'"


