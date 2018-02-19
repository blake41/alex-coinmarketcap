class HomeController < ApplicationController

  def index
    file = File.read('public/results.json')
    require 'json'
    @data = JSON.parse(file)
    @map = {}
    Currency.pluck(:id, :name).each {|id, name| @map[id] = name}
  end
end
