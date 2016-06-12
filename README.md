Conway's Game of Life Automaton
===============================

1. Application takes an -i(input) argument which represents a file that contains first state of automaton (first generation).

```winbatch
ruby game.rb input_file nr_of_generations
```

2. For input file will be created an bidimensional array with according number of rows and columns.
   After all the data from input will be loaded to a new bidimensional array.
   
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
   
2. Application takes -n (number of iterations) argument which represents a number of generations.

3. Application creates an output file which represents a file with final state.

For each generation created array will be checked if it needs to be maximized or minimized.