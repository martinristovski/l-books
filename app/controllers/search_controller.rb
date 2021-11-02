require 'ostruct'

class SearchController < ApplicationController
  def index
    @search_types = form_search_types
  end

  def search_from_home

  end

  private
  def form_search_types
    c1 = OpenStruct.new(:display_name => "Title/Author", :id => "titleauthor")
    c2 = OpenStruct.new(:display_name => "Course Number", :id => "course")
    c3 = OpenStruct.new(:display_name => "ISBN", :id => "isbn")
    [c1, c2, c3]
  end
end
