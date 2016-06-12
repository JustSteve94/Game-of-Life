require './grid'
require './cell'

class Game
  
  def initialize(inputFile, generations)
    raise "Please enter: ruby game.rb inputFile generationsNr" if generations.nil? or inputFile.nil?
    @generation   = 1
    @delay        = 0.5
    @grid         = Grid.new(inputFile)
    @generations  = generations.to_i
  end

  def run!
    @generations.times do
      system "cls"
      puts "Generation #{@generation}"
      puts @grid.display_output
      @grid.write_output
      sleep @delay
      @grid.next!
      @generation += 1
    end
  end
end

Game.new(ARGV[0], ARGV[1]).run!