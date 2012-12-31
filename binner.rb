#configuration
BinSize = 0.10
MinBin = 0.3
MaxBin = 4.0

#load code outside this file
$: << File.dirname(__FILE__)
require 'lib/excel'
require 'lib/array_stats'

#get the data out of the excel file
data = {}
data[:input_filename] = ARGV[0]
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
data_idx = 0
bin_idx = 0
curBin = MinBin
while (curBin <= MaxBin)
  #set the bin floor and ceiling
  #set in a way that corrects for floating point slop, by truncating into string and casting back into a float
  curBin = ("%0.4f" % (MinBin + (bin_idx * BinSize))).to_f
  binMax = ("%0.4f" % (curBin + BinSize)).to_f
  values = []

  #put values out of sorted list into the current bin 
  while ((data_idx < data[:length]) && (data[:sorted][data_idx] < binMax))
    values << data[:sorted][data_idx]
    data_idx += 1
  end
  
  #store the bin
  bin_label = "#{"%0.2f" % curBin} -> #{"%0.2f" % binMax}" 
  data[:bins][bin_label] = { :values => values }

  bin_idx += 1
end


#process the bins, calculate bin stats
data[:bins].each_pair do |bin_label, bin|
  bin[:length] = bin[:values].length
  #calculate the frequency
  bin[:frequency] = bin[:length].to_f / data[:length].to_f
  #standard deviation
  bin[:sample_standard_deviation] = bin[:values].sample_standard_deviation
  #sample_standard_error
  bin[:standard_error] = bin[:values].standard_error_of_the_mean
end

#output the bins

data[:output_filename] = 'processed_' + File.basename(data[:input_filename]).gsub(/\s/,'_').downcase
ExcelIO.write_bin_file data

puts "output written to '#{data[:output_filename]}'"


