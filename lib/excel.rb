require 'rubygems'
require 'roo'
require 'writeexcel'

module ExcelIO
  def self.read_length_data filename
    input_data = Excel.new(filename)
    input_data.default_sheet = input_data.sheets[0]
    values = input_data.column(1)
    values.map! { |v| v.to_f }
    return values
  end

  def self.write_array_to_sheet workbook, sheet_name, array
    worksheet = workbook.add_worksheet sheet_name
    
    array.each_index do |i|
      worksheet.write(i, 0, array[i])
    end
  end

  def self.write_bin_values workbook, data
    worksheet = workbook.add_worksheet 'bin_values'

    header_format = workbook.add_format
    header_format.set_bold

    row = 0
    data[:bins].keys.sort.each do |bin|
      worksheet.write(row, 0, bin, header_format)
      column = 1
      data[:bins][bin][:values].each do |value|
        worksheet.write(row, column, value)
        column += 1
      end
      row += 1
    end
  end

  def self.write_bin_stats workbook, data
    worksheet = workbook.add_worksheet 'bin_stats'

    header_format = workbook.add_format
    header_format.set_bold

    float_format = workbook.add_format 
    float_format.set_num_format('0.0000')

    worksheet.write(0, 0, 'Bin', header_format)
    worksheet.write(0, 1, 'Count', header_format)
    worksheet.write(0, 2, 'Frequency', header_format)
    worksheet.write(0, 3, 'Sample Std Dev', header_format)
    worksheet.write(0, 4, 'Std Err', header_format)

    row = 1
    data[:bins].keys.sort.each do |bin|
      worksheet.write(row, 0, bin, header_format)

      worksheet.write(row, 1, data[:bins][bin][:length])
      worksheet.write(row, 2, data[:bins][bin][:frequency], float_format)
      worksheet.write(row, 3, data[:bins][bin][:sample_standard_deviation], float_format)
      worksheet.write(row, 4, data[:bins][bin][:standard_error], float_format)

      row += 1
    end
  end

  def self.write_charts workbook, data
    hist = workbook.add_chart(:name => 'frequency_histogram', :type => 'Chart::Column')
    num_bins = data[:bins].length
    hist.add_series(
      :categories  => "=bin_stats!$A$2:$A$#{num_bins}",
      :values      => "=bin_stats!$C$2:$C$#{num_bins}",
      :name        => "Frequency"
    )
  end


  def self.write_bin_file data
    workbook = WriteExcel.new data[:output_filename]

    #write raw & sorted data
    write_array_to_sheet(workbook, 'raw_data', data[:raw])
    write_array_to_sheet(workbook, 'sorted_data', data[:sorted])
    write_bin_values(workbook, data)

    write_bin_stats(workbook, data)

    write_charts(workbook, data)

    workbook.close    
  end

end

