#Main file

class Game
  attr_accessor :universe, :cells
  def initialize(universe = Universe.new, cells=[])
    @universe = universe
    @cells = cells
    cells.each do |cell|
      universe.cell_universe[cell[0]][cell[1]].alive = true
    end
  end
  def turn!
    store_live_cells = []
    store_dead_cells = []
    universe.cells.each do |cell|
      #Rule 1
      if cell.alive? and universe.neighbours(cell).count < 2
        store_dead_cells << cell
        #cell.die!
      end
      #Rule 2
      if cell.alive? and ([2,3].include? universe.neighbours(cell).count)
        store_live_cells << cell
        #cell.live!
      end
      #Rule 3
      if cell.alive? and universe.neighbours(cell).count > 3
        store_dead_cells << cell
        #cell.die!
      end
      #Rule 4
      if cell.dead? and universe.neighbours(cell).count == 3
        store_live_cells << cell
        #cell.live!
      end
    end

    store_live_cells.each do |cell|
      cell.live!
    end
    store_dead_cells.each do |cell|
      cell.die!
    end

  end
end

class Universe
  attr_accessor :rows, :cols, :cell_universe, :cells

  def initialize(rows=3, cols=3)
    @rows = rows
    @cols = cols
    @cells = []

    @cell_universe = Array.new(rows) do |row|
      Array.new(cols) do |col|
        cell = Cell.new(col, row)
        cells << cell
        cell
      end
    end
  end
  def neighbours(cell)
    live_neighbours = []

    #it detects a neighbour to the north
    if cell.y > 0
      n_checked = self.cell_universe[cell.y-1][cell.x]
      live_neighbours << n_checked if n_checked.alive?
    end
    #it detects a neighbour to the north-east
    if cell.y > 0  and cell.x < (cols - 1)
      n_checked = self.cell_universe[cell.y-1][cell.x+1]
      live_neighbours << n_checked if n_checked.alive?
    end
    #it detects a neighbour to the north-west
    if cell.y > 0  and cell.x > 0
      n_checked = self.cell_universe[cell.y-1][cell.x-1]
      live_neighbours << n_checked if n_checked.alive?
    end
    #it detects a neighbour to the east
    if cell.x < (cols - 1)
      n_checked = self.cell_universe[cell.y][cell.x+1]
      live_neighbours << n_checked if n_checked.alive?
    end
    #it detects a neighbour to the west
    if cell.x > 0
      n_checked = self.cell_universe[cell.y][cell.x-1]
      live_neighbours << n_checked if n_checked.alive?
    end
    #it detects a neighbour to the south
    if cell.y < (rows - 1)
      n_checked = self.cell_universe[cell.y+1][cell.x]
      live_neighbours << n_checked if n_checked.alive?
    end
    #it detects a neighbour to the south-east
    if cell.y < (rows - 1) and cell.x < (cols - 1)
      n_checked = self.cell_universe[cell.y+1][cell.x+1]
    live_neighbours << n_checked if n_checked.alive?
    end
    #it detects a neighbour to the south-west
    if cell.y < (rows - 1) and cell.x > 0
      n_checked = self.cell_universe[cell.y+1][cell.x-1]
      live_neighbours << n_checked if n_checked.alive?
    end
    live_neighbours
  end
end

class Cell
  attr_accessor :alive, :x, :y
  def initialize(x=0, y=0)
    @alive = false
    @x = x
    @y = y
  end
  def alive?
    alive
  end
  def dead?
    !alive
  end
  def die!
    @alive = false
  end
  def live!
    @alive = true
  end
end
