require 'spec_helper'
require_relative 'gol'

describe 'Game of life' do

  let!(:universe) { Universe.new }
  let!(:cell) {Cell.new(1,1)}
  context 'Universe' do
    subject { Universe.new }
    it 'Should create a new Universe object' do
      subject.is_a?(Universe).should be_true
    end
    it 'Should respond to row & cols methods' do
      subject.should respond_to(:rows)
      subject.should respond_to(:cols)
      subject.should respond_to(:cell_universe)
      subject.should respond_to(:neighbours)
      subject.should respond_to(:cells)
    end
    it 'Should create initialize cell universe' do
      subject.cell_universe.is_a?(Array).should be_true
      subject.cell_universe.each do |row|
        row.is_a?(Array).should be_true
        row.each do|col|
          col.is_a?(Cell).should be_true
        end
      end
    end
    it 'Should fill the cells array with the cells' do
      subject.cells.count.should == 9
    end
    it 'Should detect a neighbour to the north' do
      subject.cell_universe[cell.y - 1][cell.x].alive = true
      subject.neighbours(cell).count.should == 1
    end
    it 'Should detect a neighbour to the north-east' do
      subject.cell_universe[cell.y - 1][cell.x + 1].alive = true
      subject.neighbours(cell).count.should == 1
    end
    it 'Should detect a neighbour to the north-west' do
      subject.cell_universe[cell.y - 1][cell.x - 1].alive = true
      subject.neighbours(cell).count.should == 1
    end
    it 'Should detect a neighbour to the east' do
      subject.cell_universe[cell.y][cell.x + 1].alive = true
      subject.neighbours(cell).count.should == 1
    end
    it 'Should detect a neighbour to the west' do
      subject.cell_universe[cell.y][cell.x - 1].alive = true
      subject.neighbours(cell).count.should == 1
    end
    it 'Should detect a neighbour to the south' do
      subject.cell_universe[cell.y + 1][cell.x].alive = true
      subject.neighbours(cell).count.should == 1
    end
    it 'Should detect a neighbour to the south-east' do
      subject.cell_universe[cell.y + 1][cell.x + 1].alive = true
      subject.neighbours(cell).count.should == 1
    end
    it 'Should detect a neighbour to the south-west' do
      subject.cell_universe[cell.y + 1][cell.x - 1].alive = true
      subject.neighbours(cell).count.should == 1
    end
  end

  context 'Cell' do
    subject { Cell.new }
    it 'Should create a new Cell' do
      subject.is_a?(Cell).should be_true
    end
    it 'Should respond to proper methods: alive, x & y' do
      subject.should respond_to(:alive)
      subject.should respond_to(:x)
      subject.should respond_to(:y)
      subject.should respond_to(:alive?)
      subject.should respond_to(:die!)
      subject.should respond_to(:live!)

    end
    it 'Should initialize alive = false' do
      subject.alive.should be_false
      subject.x.should == 0
      subject.y.should == 0
    end
  end

  context 'Game' do
    subject { Game.new }
    it 'Should create a new Game' do
      subject.is_a?(Game).should be_true
    end
    it 'Should respond to proper methods: initialize' do
      subject.should respond_to(:universe)
      subject.should respond_to(:cells)
    end
    it 'Should initialize properly universe & cells' do
      subject.universe.is_a?(Universe).should be_true
      subject.cells.is_a?(Array).should be_true
    end
    it 'Should fill cells properly' do
      game = Game.new(universe, [[1,2], [0,2]])
      universe.cell_universe[1][2].should be_alive
      universe.cell_universe[0][2].should be_alive
    end

  end

  context 'Rules' do
    let!(:game) { Game.new }
    context '1. Any live cell with fewer than two live neighbours dies, as if caused by under-population.' do
      it 'Should kill a live cell with 1 live neighbour' do
        game = Game.new(universe, [[0,2], [2,2]])
        game.turn!
        universe.cell_universe[0][2].should be_dead
        universe.cell_universe[2][2].should be_dead
      end
      it 'Should kill a live cell with 1 neighbour' do
        game = Game.new(universe, [[0,0],[0,1],[0,2]])
        game.turn!
        universe.cell_universe[0][0].should be_dead
        universe.cell_universe[0][1].should be_alive
        universe.cell_universe[0][2].should be_dead
      end
    end
    context '2. Any live cell with two or three live neighbours lives on to the next generation.' do
      it 'Should survive a live cell with two or three neighbours' do
        game = Game.new(universe, [[0,0],[0,2],[1,1],[2,0]])
        universe.neighbours(universe.cell_universe[1][1]).count.should == 3
        game.turn!
        universe.cell_universe[0][0].should be_dead
        universe.cell_universe[0][2].should be_dead
        universe.cell_universe[1][1].should be_alive
        universe.cell_universe[2][0].should be_dead
      end
    end
    context '3. Any live cell with more than three live neighbours dies, as if by overcrowding.' do
      it 'Should kill a live cell with 4 live neighbours' do
        game = Game.new(universe, [[0,0],[0,1],[0,2],[1,1],[1,0]])
        universe.neighbours(universe.cell_universe[1][1]).count.should > 3
        game.turn!
        universe.cell_universe[0][0].should be_alive
        universe.cell_universe[0][1].should be_dead
        universe.cell_universe[0][2].should be_alive
        universe.cell_universe[1][0].should be_alive
        universe.cell_universe[1][1].should be_dead
      end
    end
    context '4. Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.' do
      it 'Should alive a dead cell with 3 live neighbours' do
        game = Game.new(universe, [[0,0],[0,1],[1,0]])
        universe.neighbours(universe.cell_universe[1][1]).count.should == 3
        game.turn!
        universe.cell_universe[0][0].should be_alive
        universe.cell_universe[0][1].should be_alive
        universe.cell_universe[1][0].should be_alive
        universe.cell_universe[1][1].should be_alive
      end
    end
  end
end
