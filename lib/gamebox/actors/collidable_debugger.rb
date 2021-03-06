require 'actor'
require 'actor_view'

class CollidableDebugger < Actor
  
  attr_reader :actor
  def setup
    @actor = opts[:collider]
    @actor.when :remove_me do
      remove_self
    end

  end
end

class CollidableDebuggerView < ActorView

  def setup
    @color = Color[:white]
  end

  def draw(target,x_off,y_off)
    collider = @actor.actor
    case collider.collidable_shape
    when :circle
      target.draw_circle [x_off+collider.center_x, y_off+collider.center_y], collider.radius, @color
    else
      collider.cw_world_lines.each do |line|
        f = line.first
        l = line.last
        target.draw_line [x_off+f[0],y_off+f[1]],[x_off+l[0],y_off+l[1]], @color
      end
    end
  end
end
