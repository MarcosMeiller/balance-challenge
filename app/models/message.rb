class Message < ApplicationRecord

  before_save :control_balance

  # {antes de guardar siempre llama a control_balance}
  def control_balance
    self.is_balanced = check_balance(content)
  end
  # {este es el primer control que crea las variables y las llama}
  def check_balance(content)
    count = 0
    @balanced = false
    @count_left = 0 # {contador de llaves que abren "("}
    @pos_left = [] #{posicion de las llaves que abren}
    @count_right = 0 # {contador de llaves que cierran "(" }
    @pos_right = [] #{posicion de las llaves que cierran}
    @pos_dot = [] #{posicion de los :}

    while count < content.length # {recorro el array hasta el final}
      case content[count]
      when '('
        @count_left += 1 # {como encontre un parentesis que abre llamo a la funcion y lo sumo si es que cumple con los requisitos}
        @pos_left[@pos_left.length] = count #if pos_left.length == 0

      when ')' # {lo mismo que con el condicional anterior}
        @count_right += 1
        @pos_right[@pos_right.length] = count
      when ':'
        @pos_dot[@pos_dot.length] = count
      end
      count += 1
    end
    if @count_left == 0 && @count_right == 0
        @balanced = true
    elsif @count_right == 0 && @count_left > 0
        @count_left = check_aux(@pos_left,@count_left,content)
    elsif @count_left == 0 && @count_right > 0
        @count_right = check_aux(@pos_right,@count_right,content)
    elsif @count_left != @count_right && @pos_dot != []
        check_pos(content)
    else
        @balanced = false
    end

    if @count_right == @count_left && check_closed
      @balanced = true
    else
      @balanced = false
    end
  end

  def check_pos(content)
    i = 0
    j = 0
    cpy_count_right = 0
    cpy_count_left = 0
    if @count_left > @count_right
        while @pos_dot.length > j 
            while @pos_left.length > i
                if @pos_left[i] - @pos_dot[j] == 1
                    @count_left -= 1
                end
                @balanced = true if @count_right == @count_left
                break if @balanced == true
                i += 1
            end
            break if @balanced == true
            i = 0
            j += 1
        end
    else
        while @pos_dot.length > j 
        i = 0
        cpy_count_right = @count_right
            while @pos_right.length > i

                if @pos_right[i] - @pos_dot[j] == 1
                    @count_right -= 1
                end
                i += 1
                break if cpy_count_right != @count_right
            end
            @balanced = true if @count_right == @count_left 
            break if @balanced == true
            i = 0
            j += 1
        end
    end
  end

  def check_closed
    closed = true
    closed_count = 0
    i = 0
    j = 0
    not_closed = 0
    while @pos_right.length > i
        while @pos_left.length > j 
            if @pos_right[i] < @pos_left[j] && !check_emotes(content[@pos_right[i] - 1] + content[@pos_right[i]])
                not_closed += 1
  
                return closed = false if not_closed == @pos_right.length || j == @pos_left.length
            end
        j += 1
        end
        i += 1
        j = 0
    end
    not_closed = 0 
    while @pos_left.length > i
        while @pos_right.length > j 
            if (@pos_left[i] > @pos_right[j] && !check_emotes(content[@pos_left[i] + 1] + content[@pos_left[i]])) 
                not_closed += 1
                closed = false
                return closed = false if not_closed == @pos_left.length  || i == @pos_right.length 
            end
        j += 1
        end
        j = 0
        i += 1
    end
    return closed
  end

  def check_aux (array,count,content)
    i = 0
    dat = ""
    array.each do |element|
        if check_emotes(content[element - 1] + content[element])
            count -= 1
        end
    end
    return count
  end

  def check_emotes(check)
    emoticons = [':)', ':(']
    flag = false
    emoticons.each do |emoticon|
      flag = true if emoticon == check
    end
    flag
 end

end