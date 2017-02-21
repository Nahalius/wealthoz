module PivotTable
  def grid(data, options = {})
    grid = PivotTable::Grid.new do |g|
      g.source_data = data
      g.column_name = options[:column_name]
      g.row_name = options[:row_name]
    end
  end
end