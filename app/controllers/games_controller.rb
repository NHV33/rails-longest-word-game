require 'uri'
require 'net/http'

class GamesController < ApplicationController
  def new
    @vowels = "AAIIUUEEOO".chars
    @ABCs = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".chars
    @letters = @vowels.sample(3) + @ABCs.sample(3) + @ABCs.sample(4)
  end

  def spellable?(word, letters)
    word = word.upcase
    letters = letters.split
    is_valid = true
    word.chars.each do |letter|
      if letters.include?(letter)
        letters.delete_at(letters.index(letter))
      else
        is_valid = false
        break
      end
    end
    return is_valid
  end

  require 'uri'
  require 'net/http'

  def score
    @word = params[:word]
    @letters = params[:letters]
    uri = URI("https://wagon-dictionary.herokuapp.com/#{@word}")
    res = Net::HTTP.get_response(uri)
    @valid_english = false
    if res.is_a?(Net::HTTPSuccess)
      @valid_english = JSON.parse(res.body)["found"]
    end

    @valid_letters = spellable?(@word, @letters)

    @result_message = "Great job! \"#{@word}\" earns you #{@word.chars.length} points."

    unless @valid_english
      @result_message = "\"#{@word}\" is not valid English."
    end

    unless @valid_letters
      @result_message = "\"#{@word}\" cannot be spelled from \"#{@letters}\"."
    end
  end
end
