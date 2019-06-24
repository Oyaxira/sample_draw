class WordsController < ApplicationController

  def index
    @words = Word.all
  end

  def new
    @word = Word.new
  end

  def create
    @word = Word.find_or_create_by(word_params)
    redirect_to words_path
  end

  private
    def word_params
      params.require(:word).permit([
        :name,
        :word_type
      ])
    end
end
