require 'curses'
module Draw
  def position_y
    (@position[:y] / 2).floor * 2
  end

  def draw
    @object_array.each_with_index do |row, y|
      row.each_with_index do |cell, x|
        next if cell.zero?

        @window.attron(Curses.color_pair(cell))
        @window.setpos(position_y + y, @position[:x] + x)
        @window.addch(cell.to_s)
        @window.attroff(Curses.color_pair(cell))
      end
    end
  end
end
