#-------------------------------------------------------------------

# Game of "Life" or how to simulate the "evolution"

# Description:s
#  - Every cell has two states: ALIVE or DEAD
#  - Any live cell with fewer than two live neighbors dies, as if by
#    underpopulation.
#  - Any live cell with two or three live neighbors lives on to the next
#    generation.
#  - Any live cell with more than three live neighbors dies, as if by
#    overpopulation.
#  - Any dead cell with exactly three live neighbors becomes a live cell,
#    as if by reproduction.

#-------------------------------------------------------------------

# Class to represent the Universe
class Universe
  ALIVE = 1
  DEAD  = 0

  def initialize(size_i: 10, size_j: 20)
    @size_i = size_i
    @size_j = size_j
    @planet = create_planet # create main array
    @temp_planet = create_planet # create supporting array
  end

  # Print Universe
  def show
    @planet.each_index do |i|
      @planet[i].each_index do |j|
        @planet[i][j] == ALIVE ? print('x') : print('-')
      end
      puts ''
    end
    puts ''
  end

  # Check life in the cell
  # return value: if alive returns TRUE, else FALSE
  def cell_alive?(pos_i, pos_j)
    @planet[pos_i][pos_j] == ALIVE
  end

  # Check the number of alive cells around
  # That's an array is used to get neighbors addres
  #     [-1, -1]  [-1, 0 ]  [-1, +1]
  #     [ 0, -1]  [ CELL ]  [ 0, +1]
  #     [+1, -1]  [+1, 0 ]  [+1, +1]
  # return value: the number of alive cells around the cell[pos_i][pos_j]
  def check_neighbors(pos_i, pos_j)
    neighbors_count = 0
    [-1, 0, 1].each do |i|
      [-1, 0, 1].each do |j|
        neighbor_i_pos = pos_i + i > (@size_i - 1) ? 0 : pos_i + i
        neighbor_j_pos = pos_j + j > (@size_j - 1) ? 0 : pos_j + j
        @planet[neighbor_i_pos][neighbor_j_pos] == ALIVE && neighbors_count += 1
      end
    end
    # deleting a cell[pos_i][pos_j] from an amount of neighbors
    # (it is not a neighbor for itself)
    @planet[pos_i][pos_j] == ALIVE && neighbors_count -= 1
    neighbors_count
  end

  # Calculating new generation
  def make_next_generation
    @planet.each_index do |i|
      @planet[i].each_index do |j|
        neighbors_count = check_neighbors(i, j)
        if cell_alive?(i, j)
          @temp_planet[i][j] = neighbors_count.between?(2, 3) ? ALIVE : DEAD
        else
          @temp_planet[i][j] = neighbors_count == 3 ? ALIVE : DEAD
        end
      end
    end
    copy_planet(@temp_planet, @planet)
  end

  private

  # Creating an array that represents the Universe
  def create_planet
    new_planet = Array.new(@size_i)
    new_planet.each_index do |i|
      new_planet[i] = Array.new(@size_j)
    end
    init_planet(new_planet)
  end

  # Initialize Universe
  # fills an array with random values in [0..1]
  def init_planet(planet)
    planet.each_index do |i|
      planet[i].each_index do |j|
        god_says = rand(2)
        planet[i][j] = god_says == ALIVE ? ALIVE : DEAD
      end
    end
  end

  # Copy planet
  def copy_planet(planet_from, planet_to)
    planet_from.each_index do |i|
      planet_from[i].each_index do |j|
        planet_to[i][j] = planet_from[i][j]
      end
    end
    planet_to
  end
end

# Main part

puts 'Enter the size of the Universe'
print 'Rows (18 is recommended): '
rows = gets.chomp
print 'Columns (80 is recommended): '
columns = gets.chomp
print 'Enter the number of generations: '
generations_count = gets.chomp

universe = Universe.new(size_i: rows.to_i, size_j: columns.to_i)
generations_count.to_i.times do |i|
  puts '----------------------------------'
  puts "           Turn #{i + 1}              "
  puts ''
  universe.show
  universe.make_next_generation
  sleep(0.2)
end
