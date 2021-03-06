require 'actor_view'

class GraphicalActorView < ActorView
  def draw(target, x_off, y_off, z)
    x = @actor.x
    y = @actor.y

    offset_x = x+x_off
    offset_y = y+y_off

    img = @actor.image
    return if img.nil?

    #if @actor.is? :animated or 
    if @actor.is? :physical
      img_w = img.width
      img_h = img.height

      offset_x = x-img_w/2 + x_off
      offset_y = y-img_h/2 + y_off
      img.draw_rot offset_x, offset_y, z, @actor.rotation
    else
      graphical_behavior = @actor.graphical if @actor.is? :graphical
      if graphical_behavior && graphical_behavior.tiled?
        x_tiles = graphical_behavior.num_x_tiles
        y_tiles = graphical_behavior.num_y_tiles
#        img_w, img_h = *img.size
        img_w = img.width
        img_h = img.height
        x_tiles.times do |col|
          y_tiles.times do |row|
#            img.blit target.screen, [offset_x+col*img_w,offset_y+row*img_h]
            img.draw offset_x+col*img_w, offset_y+row*img_h, z
          end
        end
      else
#        img.blit target.screen, [offset_x,offset_y]
        img.draw offset_x, offset_y, z
      end
    end
    target.draw_line(offset_x,offset_y,offset_x+1,offset_y+1,[255,10,10],z)
  end
end
