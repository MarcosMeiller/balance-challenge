# frozen_string_literal: true

class Message < ApplicationRecord
  # Ex:- :default =>''

  before_save :control_balance

  # {antes de guardar siempre llama a control_balance}
  def control_balance
    self.is_balanced = check_balance(content)
  end

  # {este es el primer control que crea las variables y las llama}
  def check_balance(content)
    count = 0
    @count_left = 0 # {contador de llaves que abren "("}
    @count_right = 0 # {contador de llaves que cierran "(" }
    while count < content.length # {recorro el array hasta el final}
      case content[count]
      when '('
        @count_left += check_emoticon(content, count) # {como encontre un parentesis que abre llamo a la funcion y lo sumo si es que cumple con los requisitos}
      when ')' # {lo mismo que con el condicional anterior}
        @count_right += check_emoticon(content, count)
      end
      count += 1
    end

    final_check(content) # {hago un ultimo checkeo para aplicar la regla 5}

    @count_left == @count_right
  end

  # {aca se checkea la regla 5 recorriendolo desde atras y checkeando que no haya problemas con el length del string}
  def final_check(content)
    flag = false
    count = content.length
    if count > 3 && @count_left != @count_right
      while count.positive?
        if content[count] == ')' && (count - 2).positive?
          flag = check_emotes_inside(content[count - 3] + content[count - 2] + content[count - 1] + content[count])
          count -= 3 if flag
        end
        if flag
          flag = false
        else
          count -= 1
        end
      end
    end
  end

  # {funcion que hace el primer recorrido del string, donde compruebo todas las reglas menos la 5}
  def check_emoticon(content, count)
    check_emote_left = ''
    check_emote_right = ''
    result = false
    if count.positive? && count + 1 < content.length
      if check_eyes(content[count - 1]) && content[count - 2] != '('
        check_emote_left = content[count - 1] + content[count]
      end
      if check_eyes(content[count + 1]) && content[count + 2] != ')'
        check_emote_right = content[count] + content[count + 1]
      end

      if content.length - count > 2 # {compruebo esto para no tener problemas con el tamaño del index}
        if check_points_inside(content[count] + content[count + 1] + content[count + 2]) || check_points_inside(content[count - 2] + content[count - 1] + content[count])
          return 0
        end
      elsif count > 1 # {en caso de que no uso esta funcion}
        return 0 if check_points_inside(content[count - 2] + content[count - 1] + content[count]) # {checkeo la regla 2}
      end
    elsif count.zero? # {en caso de encontrar desde el inicio el parentesis}
      if content.length > 2 # {checkeo para no tener error de index}
        if check_eyes(content[count + 1]) && content[count + 2] != ')'
          check_emote_right = content[count] + content[count + 1]
        end
        if check_points_inside(string = content[count] + content[count + 1] + content[count + 2])
          count += 2
          return 0 # {retorno 0 en caso de que se cumpla la regla 2 con los "(:)"}
        end
      elsif check_eyes(content[count + 1])
        check_emote_right = content[count] + content[count + 1]
      end
    elsif count == content.length - 1 # {en caso de estar en la ultima pos del string}
      if  content.length - count > 3 # {checkeo que sea mayor a 3 para no tener problemas con el tamaño del index}
        if check_eyes(content[count - 1]) && content[count] != '(' && !check_points_inside(content[count] + content[count - 1] + content[count - 2])
          check_emote_left = content[count - 1] + content[count]
        end
        if check_points_inside(string = content[count] + content[count + 1] + content[count - 2])
          check_emote_right = ''
        end
      elsif check_eyes(content[count - 1]) && content[count] != '('
        check_emote_left = content[count - 1] + content[count]
      end
    end

    if check_emotes(check_emote_left) || check_emotes(check_emote_right) # {checkeo si encontro un parentesis que no pertenezca a un emote y retorno 1 si encontro sino 0}
      0
    else
      1
    end
  end

  # {controla la regla 2}
  def check_points_inside(string)
    array = ['(:)', '(;)']
    flag = false
    array.each do |element|
      flag = true if element == string
    end
    flag
  end

  # {controla la regla 5}
  def check_emotes_inside(string)
    array = ['(:))', '(;))', '((:)', '((;)']
    flag = false
    array.each do |element|
      next unless element == string

      flag = true
      if string == array[0] || string == array[1]
        @count_right -= 1
      else
        @count_left -= 1
      end
    end
    flag
  end

  # {controla los ; y : para los emotes}
  def check_eyes(string)
    array = [':', ';']
    flag = false
    array.each do |element|
      flag = true if element == string
    end
    flag
  end

  # {controla los emotes}
  def check_emotes(check)
    emoticons = [':)', ':(', '(:', '):', ';)', ';(', '(;', ');']
    flag = false
    emoticons.each do |emoticon|
      flag = true if emoticon == check
    end
    flag
  end
end