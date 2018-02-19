
class Output
  FILE = '/Users/blake/Downloads/CyrptoHistoricData.xlsx'
  attr_reader :file

  def initialize(file = FILE)
    @file = file
  end

  def write_data
    xl = RubyXL::Parser.parse(file); puts 'hi'
    sheet = xl['Price']
    binding.pry
    puts 'h'
  end

end
