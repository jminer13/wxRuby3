#!/usr/bin/env ruby
# wxRuby2 Sample Code. Copyright (c) 2004-2008 wxRuby development team
# Adapted for wxRuby3
# Copyright (c) M.J.N. Corino, The Netherlands
###

require 'wx'

class MyTextCellEditor < Wx::GRID::GridCellTextEditor
  def apply_edit(row, col, grid)
    grid.set_cell_value(row, col, "'#{get_value}'" )
  end
end

class GridFrame < Wx::Frame

  def initialize(parent, id = -1, title = "MyFrame", 
                  pos   = Wx::DEFAULT_POSITION,
                  size  = Wx::DEFAULT_SIZE,
                  style = Wx::DEFAULT_FRAME_STYLE)

    super(parent, id, title, pos, size, style)
    sizer = Wx::BoxSizer.new(Wx::VERTICAL)
    create_status_bar
    set_status_text(Wx::WXRUBY_VERSION)

    # panel = Wx::Panel.new(self)
    sel_menu = Wx::Menu.new
    sel_menu.append(1002, 'Select all', 'Select all')
    evt_menu(1002) { @grid.select_all }
    sel_menu.append(1003, 'Select row 2', 'Select row 2')
    evt_menu(1003) { @grid.select_row(1) }
    sel_menu.append(1004, 'Select column 4', 'Select col 4')
    evt_menu(1004) { @grid.select_col(3) }
    sel_menu.append(1005, 'Select block', 'Select block')
    evt_menu(1005) { @grid.select_block(1, 1, 6, 3) }
    menu_bar = Wx::MenuBar.new
    menu_bar.append(sel_menu, 'Select')
    set_menu_bar(menu_bar)

    make_grid(self)
    sizer.add(@grid, 1, Wx::ALL|Wx::GROW, 4)
    set_sizer(sizer)

    evt_grid_cell_left_click do |evt|
      set_status_text("#{evt.get_row} x #{evt.get_col} is clicked")
      evt.skip
    end 

    evt_grid_cell_right_click do |evt|
      set_status_text("#{evt.get_row} x #{evt.get_col} is right clicked")
      evt.skip
    end 

    evt_grid_cell_left_dclick do |evt|
      set_status_text("#{evt.get_row} x #{evt.get_col} is double clicked")
      evt.skip
    end 

    evt_grid_cell_right_dclick do |evt|
      set_status_text("#{evt.get_row} x #{evt.get_col} is right double clicked")
      evt.skip
    end 

    evt_grid_label_left_click do |evt|
      set_status_text("#{evt.get_row} x #{evt.get_col} label is clicked")
      evt.skip
    end 

    evt_grid_label_right_click do |evt|
      set_status_text("#{evt.get_row} x #{evt.get_col} label is right clicked")
      evt.skip
    end 

    evt_grid_label_left_dclick do |evt|
      set_status_text("#{evt.get_row} x #{evt.get_col} labelis double clicked")
      evt.skip
    end 

    evt_grid_label_right_dclick do |evt|
      set_status_text("#{evt.get_row} x #{evt.get_col} label is right double clicked")
      evt.skip
    end 

    evt_grid_select_cell do |evt|
      set_status_text("#{evt.get_row} x #{evt.get_col} cell is selected")
      evt.skip
    end
    
    evt_grid_row_size do |evt|
      set_status_text("Row #{evt.get_row_or_col} size changed")
      evt.skip
    end

    evt_grid_col_size do |evt|
      set_status_text("Column #{evt.get_row_or_col} size changed")
      evt.skip
    end

    evt_grid_editor_shown do |evt|
      set_status_text("Begin editing")
      evt.skip
    end

    evt_grid_editor_hidden do |evt|
      set_status_text("End editing")
      evt.skip
    end

    evt_grid_range_selected do |evt|
      top = evt.get_top_left_coords
      bottom = evt.get_bottom_right_coords
      set_status_text("[ #{top[0].to_s} x #{top[1].to_s} ] to [ #{bottom[0].to_s} x #{bottom[1].to_s} ] is selected")
    end 

    evt_grid_editor_created do |evt|
      set_status_text("Control #{evt.get_control} created")
      evt.skip
    end

    evt_grid_cell_changed do |evt|
      set_status_text("Cell #{evt.get_row} x #{evt.get_col} has changed")
    end
  end

  # Create a wxGrid object
  def make_grid(panel)
    @grid = Wx::GRID::Grid.new(panel, -1)

    # Then we call CreateGrid to set the dimensions of the grid
    # (11 rows and 12 columns in this example)
    @grid.create_grid( 20, 12 )
    @grid.set_default_cell_background_colour(Wx::WHITE)
    # We can set the sizes of individual rows and columns
    # in pixels, and the label value string
    @grid.set_row_size( 0, 60 )
    @grid.set_row_label_value( 0, "Row1" )
    @grid.set_row_label_alignment(Wx::ALIGN_CENTRE, Wx::ALIGN_CENTRE)
    
    @grid.set_col_size( 0, 120 )
    @grid.set_col_label_value( 0, "Col1" )
    @grid.set_col_label_alignment(Wx::ALIGN_CENTRE, Wx::ALIGN_CENTRE)
    
    # And set grid cell contents as strings
    @grid.set_cell_value( 0, 0, "wxGrid is good" )

    # We can specify that some cells are read-only
    @grid.set_cell_value( 0, 2, "Read-only" )
    @grid.set_read_only( 0, 2 )

    cell_attr = Wx::GRID::GridCellAttr.new
    cell_attr.editor = MyTextCellEditor.new
    @grid.set_row_attr(1, cell_attr)
    cell_attr2 = Wx::GRID::GridCellAttr.new
    cell_attr2.editor = cell_attr.editor(@grid, 1, 1)
    @grid.set_row_attr(2, cell_attr2)

    # Colours can be specified for grid cell contents
    @grid.set_cell_value(1, 1, "white on red")
    @grid.set_cell_text_colour(1, 1, Wx::WHITE)
    @grid.set_cell_background_colour(1, 1, Wx::RED)

    # We can specify the some cells will store numeric 
    # values rather than strings. Here we set grid column 6 
    # to hold floating point values displayed with width 
    # of 2 and precision of 2. The column is highlighted in light grey
    cell_attr = Wx::GRID::GridCellAttr.new
    cell_attr.set_background_colour( Wx::LIGHT_GREY )
    cell_attr.set_renderer( Wx::GRID::GridCellFloatRenderer.new(2, 2) )

    @grid.set_col_attr(5, cell_attr)
    @grid.set_cell_value(0, 5, "3.1415")
    @grid.set_cell_value(0, 6, 
                         "The whole column to the left uses float format")
    
    # Custom Editors Can be used
    editor = Wx::GRID::GridCellNumberEditor.new(5, 20)
    @grid.set_cell_value(3, 1, 'Number editor below')
    @grid.set_cell_editor(4, 1, editor)

    editor = Wx::GRID::GridCellFloatEditor.new(4, 2)
    @grid.set_cell_value(3, 2, 'Float editor below')
    @grid.set_cell_editor(4, 2, editor)

    editor = Wx::GRID::GridCellChoiceEditor.new(['foo', 'bar', 'baz'])
    @grid.set_cell_value(3, 3, 'Choice editor below')
    @grid.set_cell_editor(4, 3, editor)

    @grid.auto_size_row(3, true)

    # Display of cells can be customised
    @grid.set_cell_editor(6, 0, Wx::GRID::GridCellBoolEditor.new)
    @grid.set_cell_renderer(6, 0, Wx::GRID::GridCellBoolRenderer.new)
    @grid.set_cell_value(6, 1, 'Cell to the left displayed as boolean')
  end
  
end

module GridSample

  include WxRuby::Sample if defined? WxRuby::Sample

  def self.describe
    { file: __FILE__,
      summary: 'wxRuby Grid example.',
      description: 'wxRuby example showcasing Grid control features.' }
  end

  def self.activate
    frame = GridFrame.new(nil, -1, "Grid Sample",
                          Wx::Point.new(10, 100),
                          Wx::Size.new(630,400))
    frame.show
    frame
  end

  if $0 == __FILE__
    Wx::App.run do
      gc_stress
      GridSample.activate
    end
  end

end
