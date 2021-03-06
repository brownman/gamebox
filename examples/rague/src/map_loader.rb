require 'inflector'
require 'map'
require 'dungeon_generator'
require 'publisher'

# loads maps from given string array
class MapLoader
  extend Publisher
  can_fire :monster_spawned
  attr_accessor :rague
  
  def initialize(config)
    @config = config
  end
  
  def build_random_map(map, walk_length=400)
    # TODO randomize starting location
    x = 12
    y = 5
    log "Generating random map ..."
    things_to_place = ['!','!','g','g','g']
    a = Generator.new().create_dungeon(Arena.new(things_to_place), walk_length, true, Walker.new(x,y))
    a[x,y] = '@'
    a[x+1,y] = '<'
    
    puts a
    
    log "done."
    build_map map, a.to_s.split("\n")
  end
  
  def load_map(map, filename)
    full_path = File.join(DATA_PATH,'maps',filename)
    map_lines = File.open(full_path).readlines
    build_map map, map_lines
  end
  
  def build_map(map, map_lines)
    log "Building map..."
    map.size = [map_lines[0].length-1, map_lines.size-1]
    
    map_lines.each_with_index do |row_str, row|
      row_str.strip.length.times do |col|
        x = (col-0.5) * map.tile_width
        y = (row-0.5) * map.tile_height
        
        tile_klass = @config[:tiles][row_str[col].chr]
        tile = map.spawn :tile, :x => x, :y => y, :action => tile_klass,
          :tile_x => col, :tile_y => row, :hide => true
        tile.lit = false
        tile.solid = true if tile_klass == :wall
        map.place tile.location, tile
        
        if tile_klass.nil?
          monster_name = @config[:monsters][row_str[col].chr]
          if monster_name == :rague
            act = map.spawn :rague
            @rague = act
          else
            if monster_name.nil?
              item_name = @config[:items][row_str[col].chr]
              unless item_name.nil?
                act = map.spawn :item, :name=>item_name, :hide => true
              end
            else
              act = map.spawn :monster, :name=>monster_name, :hide => true
              fire :monster_spawned, act
            end
          end
          map.move_to act, loc2(col,row) if act              
        end
        
      end
    end
    log "done."
  end
  
end