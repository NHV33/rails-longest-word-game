require 'uri'
require 'net/http'

class GamesController < ApplicationController
  def new
    @vowels = "AAIIUUEEOO".chars
    @ABCs = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".chars
    @letters = @vowels.sample(3) + @ABCs.sample(3) + @ABCs.sample(4)
  end

  def score
    @word = params[:word]
    @letters = params[:letters]
    @letters = "test"
    uri = URI("https://wagon-dictionary.herokuapp.com/#{@word}")
    res = Net::HTTP.get_response(uri)
    @word_valid = false
    if res.is_a?(Net::HTTPSuccess)
      @word_valid = JSON.parse(res.body)["found"]
    end
    @result_message = "unloaded"
    unless @word_valid
      @result_message = "#{@word} cannot be spelled from #{@letters}"
    end
  end
end
