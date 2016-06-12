Conway's Game of Life Automaton
===============================

1. Application takes an -i(input) argument which represents a file that contains first state of automaton (first generation). 
Application takes -n (number of iterations) argument which represents a number of generations.

    ```batch
    ruby game.rb input_file nr_of_generations
    ```

2. From input file will be created an bidimensional array with according number of rows and columns.
   
    ```ruby
    def build_from_file(file)
     grid = []
     file.each_with_index do |row, r_idx|
       row.split(//).each_with_index do |state, c_idx|
         grid << Cell.new(state == ALIVE, r_idx, c_idx) if state == ALIVE
       end
     end
     grid
    end
    ```
   
3. For the next generation application searches neighbours for each cell and selects alive cells.

    ```ruby
    def alive_neighbors_of(cell)
      row             = cell.row
      column          = cell.column
      create_new_cell = cell.is_alive?

      neighbours = []

      # North-West Neighbors
      neighbours.push(cell_at(row - 1, column - 1, create_new_cell))
      # North Neighbors
      neighbours.push(cell_at(row - 1, column, create_new_cell))
      # North-East Neighbors
      neighbours.push(cell_at(row - 1, column + 1, create_new_cell))
      # West Neighbors
      neighbours.push(cell_at(row, column - 1, create_new_cell))
      # East Neighbors
      neighbours.push(cell_at(row, column + 1, create_new_cell))
      # South-West Neighbors
      neighbours.push(cell_at(row + 1, column - 1, create_new_cell))
      # South Neighbors
      neighbours.push(cell_at(row + 1, column, create_new_cell))
      # South-East Neighbors
      neighbours.push(cell_at(row + 1, column + 1, create_new_cell))

      neighbours.select{|n| n && n.is_alive?}
    end
    ```

4. From the start applications takes a finite array with cells and in case of need application adds new cell
 
     ```ruby
     def cell_at(x, y, create_cell = false)
         cell = grid.select {|c| c.row == x && c.column == y}.first
         if cell.nil? and create_cell
           cell = Cell.new(false, x, y)
           @grid << cell
     
           expand_grid x, y
         end
         cell
       end
     ```
 
    and expands grid
 
    ```ruby
    def expand_grid(x, y)
       @row_low     = x if @row_low > x
       @rows        = x if @rows < x
       @columns_low = y if @columns_low > y
       @columns     = y if @columns < y
     end
    ```
 
5. Last generation is written in output file.

    ```ruby
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
    ```

