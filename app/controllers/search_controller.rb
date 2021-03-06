require 'ostruct'

class SearchController < ApplicationController
  def index
    @search_types = form_search_types
    render layout: 'other_pages'
  end

  def results
    @search_types = form_search_types
    if params[:commit] == "Go" && params[:criteria] != nil && params[:search_term] != nil && valid_criteria?(params[:criteria])
      if params[:search_term].length == 0 || params[:criteria].length == 0
        flash[:notice] = "Please enter a search term."
        redirect_to action: "index"
        return
      end

      # get search params
      c =  params[:criteria]
      st = params[:search_term].downcase  # convert to lowercase | TODO: Sanitize!

      # search by param
      # TODO: Currently searching for substrings. Make this more forgiving.
      if c == "titleauthor"
        @results = Book.where("LOWER(title) like ? OR LOWER(authors) like ?", "%#{st}%", "%#{st}%")
      elsif c == "course"
        if !(st.match /([A-Za-z][A-Za-z][A-Za-z][A-Za-z])([0-9][0-9][0-9][0-9])/)
          flash[:notice] = "Invalid course code. Please use correct input form (E.g. 'HUMA1001')."
          redirect_to action: "index"
          return
        else
          courses = Course.where("LOWER(code) like ?", "%#{st}%")
          if courses.empty?
            @results = []
          else
            all_bca = []
            courses.each do |c|
              all_bca += BookCourseAssociation.where(course_id: c.id)
            end
            @results = []
            all_bca.each do |bca|
              @results.append(bca.book) unless @results.include? bca.book
            end
          end
        end
      else # c == "isbn"
        st = st.tr('^0-9', '') # strip all non numeric chars
        @results = Book.where("isbn like ? OR isbn = ?", "%#{st}%", "%#{st}%")
      end

      render layout: 'other_pages'
    else
      flash[:notice] = "Invalid search."
      redirect_to action: "index"
    end
  end

  private
  def form_search_types
    c1 = OpenStruct.new(:display_name => "Title/Author", :id => "titleauthor")
    c2 = OpenStruct.new(:display_name => "Course Number", :id => "course")
    c3 = OpenStruct.new(:display_name => "ISBN", :id => "isbn")
    [c1, c2, c3]
  end

  def valid_criteria? c
    %w[titleauthor course isbn].include? c
  end
end
