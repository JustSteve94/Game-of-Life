class Grid

  ALIVE = '1'
  DEAD = '0'

  attr_accessor :grid

  def initialize(file_name)
    raise "No file with name: #{file_name}" unless File.exist?("#{file_name}")
    file     = File.read(file_name).split("\n")
    @rows    = file.count - 1
    @columns = file.first.split(//).count - 1

    @row_low     = 0
    @columns_low = 0

    @grid    = build_from_file file
  end

  def display_output
    output_grid = []
    (@row_low..@rows).each do |r_idx|
      o_row = []
      (@columns_low..@columns).each do |c_idx|
        cell = cell_at(r_idx, c_idx)
        o_row << ((cell && cell.is_alive?) ? '1' : '0')
      end
      output_grid << o_row
    end

    [].tap { |output|
      output << output_grid.map{|row| row.map{|cell| cell }.join}
    }.join("\n")
  end

  def write_output
    output_grid = []
    (@row_low..@rows).each do |r_idx|
      o_row = []
      (@columns_low..@columns).each do |c_idx|
        cell = cell_at(r_idx, c_idx)
        o_row << ((cell && cell.is_alive?) ? '1' : '0')
      end
      output_grid << o_row
    end

    File.delete("output.txt") if File.exist?("output.txt")
    File.open("output.txt", "w+") do |file|
      file << output_grid.map{|row| row.map{|cell| cell }.join}.join("\n")
    end
  end
  
  def next!
    grid.each do |cell|
      cell.num_alive_neighbours = alive_neighbors_of(cell).count
      cell.prepare_to_mutate!
    end

    grid.map &:mutate!

    grid.delete_if { |c| !c.is_alive? }
  end

  def cell_at(x, y, create_cell = false)
    cell = grid.select {|c| c.row == x && c.column == y}.first
    if cell.nil? and create_cell
      cell = Cell.new(false, x, y)
      @grid << cell

      expand_grid x, y
    end
    cell
  end

  private
    def build_from_file(file)
      grid = []
      file.each_with_index do |row, r_idx|
        row.split(//).each_with_index do |state, c_idx|
          grid << Cell.new(state == ALIVE, r_idx, c_idx) if state == ALIVE
        end
      end
      grid
    end

    def alive_neighbors_of(cell)
      row             = cell.row
      column          = cell.column
      create_new_cell = cell.is_alive?

      neighbours = []

      neighbours.push(cell_at(row - 1, column - 1, create_new_cell))
      neighbours.push(cell_at(row - 1, column, create_new_cell))
      neighbours.push(cell_at(row - 1, column + 1, create_new_cell))

      neighbours.push(cell_at(row, column - 1, create_new_cell))
      neighbours.push(cell_at(row, column + 1, create_new_cell))

      neighbours.push(cell_at(row + 1, column - 1, create_new_cell))
      neighbours.push(cell_at(row + 1, column, create_new_cell))
      neighbours.push(cell_at(row + 1, column + 1, create_new_cell))

      neighbours.select{|n| n && n.is_alive?}
    end

    def expand_grid(x, y)
      @row_low     = x if @row_low > x
      @rows        = x if @rows < x
      @columns_low = y if @columns_low > y
      @columns     = y if @columns < y
    end
end
