#!/usr/bin/ruby

require "rubygems"
require "ncurses"

class Field
  attr_accessor :height, :width

  def initialize(height, width)
    @height = height
    @width = width

    clear()
  end

  def clear
    @lines = []
    (0...@height).each do |y|
      line = []
      (0...@width).each do |x|
        line.append(false)
      end
      @lines.append(line)
    end
  end    

  def randomize
    (1...@height-1).each do |y|
      (1...@width-1).each do |x|
        if rand(5) % 5 == 0
          @lines[y][x] = true
        else
          @lines[y][x] = false
        end
      end
    end
  end

  def view
    (0...@height).each do |y|
      (0...@width).each do |x|
        Ncurses.move(y, x)
        if @lines[y][x] == true
          Ncurses.addstr("*")
        else
          Ncurses.addstr(" ")
        end
      end
    end
    Ncurses.refresh
  end

  def next_generation
    # make empty field
    next_lines = []
    (0...@height).each do |y|
      line = []
      (0...@width).each do |x|
        line.append(false)
      end
      next_lines.append(line)
    end
    
    (1...@height-1).each do |y|
      (1...@width-1).each do |x|
        next_lines[y][x] = judge(y, x)
      end
    end
    
    @lines = next_lines
  end

  def judge(y, x)
    n = 0
    [-1, 0, 1].each do |dy|
      [-1, 0, 1].each do |dx|
        if dy == 0 && dx == 0
          next
        end
        ny = (y + dy) % @height
        nx = (x + dx) % @width
        if @lines[ny][nx] == true
          n += 1
        end
      end
    end

    if @lines[y][x] == false && n == 3
      return true
    end
    if @lines[y][x] == true && (n == 2 || n == 3) 
      return true
    end
    
    return false
  end
end



# main

Ncurses.initscr
field = Field.new(Ncurses.LINES, Ncurses.COLS)
field.randomize

g = 1

begin
  loop do
    field.view
    field.next_generation
    sleep 0.1
    g += 1
  end
rescue
  
ensure
  Ncurses.endwin
end

