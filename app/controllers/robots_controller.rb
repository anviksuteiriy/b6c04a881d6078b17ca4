class RobotsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def orders
    return unless params[:commands]
    commands = params[:commands].upcase
    array_commands =  commands.split() #converting string into array of words for easy opertaions
    if array_commands[0] == "PLACE" #checking if PLACE command is there or not
      current_x = nil #variable declaration for global scope
      current_y = nil
      current_facing = "NORTH"
      if array_commands[1]
        incoming_location = array_commands[1].split(",") #splitting 2nd element so that we can get location, (this is happening because of the format which can be improvised and thus this operation can also be changed)
        current_x = incoming_location[0].to_i
        current_y = incoming_location[1].to_i
        if current_x >= 0 && current_y >= 0 #checking if given origin is positive so that we can place robot on table
          if incoming_location[2]
            #assuming that after origin location first command will be a direction
            case incoming_location[2]
            when "NORTH"
              current_facing = "NORTH"
            when "EAST"
              current_facing = "EAST"
            when "SOUTH"
              current_facing = "SOUTH"
            when "WEST"
              current_facing = "WEST"
            end
            current_facing, current_x, current_y = calculate_current_location(array_commands, current_y, current_x, current_facing)
          end
        else
          render json: {error: "I am not on table"}, status: :unprocessable_entity and return
        end
        if current_x < 0 || current_y < 0
          render json: {error: "Can't Move, I will Fall"}, status: :unprocessable_entity and return
        else
          if array_commands.last == "REPORT"
            #success response
            final_response = "#{current_x},#{current_y},#{current_facing}"
            render json: {success: true, location: final_response }, status: :ok
          else
            render json: {error: "No REPORT Command Found"}, status: :unprocessable_entity and return
          end
        end
      else
        render json: {error: "No REPORT Command Found"}, status: :unprocessable_entity and return
      end
    else
      render json: {error: "Invalid Command, please include PLACE Command at start"}, status: :unprocessable_entity and return
    end
  end
end

#function to calculate location
def calculate_current_location(array_commands, current_y, current_x, current_facing)
  array_commands.each_with_index do | elem, index|
    if index = 2
      case elem
      when "MOVE"
        case current_facing
        when "NORTH"
          current_y += 1
        when "EAST"
          current_x += 1
        when "SOUTH"
          current_y -= 1
        when "WEST"
          current_x -= 1
        end
      when "LEFT"
        case current_facing
        when "NORTH"
          current_facing = "WEST"
        when "EAST"
          current_facing = "NORTH"
        when "SOUTH"
          current_facing = "EAST"
        when "WEST"
          current_facing = "SOUTH"
        end
      when "RIGHT"
        case current_facing
        when "NORTH"
          current_facing = "EAST"
        when "EAST"
          current_facing = "SOUTH"
        when "SOUTH"
          current_facing = "WEST"
        when "WEST"
          current_facing = "NORTH"
        end
      end
    end
  end
  return current_facing, current_x, current_y
end