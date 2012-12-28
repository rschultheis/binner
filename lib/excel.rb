require 'rubygems'
require 'roo'

module ExcelIO
  def self.read_length_data filename
    input_data = Excel.new(filename)
    input_data.default_sheet = input_data.sheets[0]
    values = input_data.column(1)
    values.map! { |v| v.to_f }
    return values
  end
end

