class PostHereController < ApplicationController

  def show
    render :action => 'show', :layout => false
  end

  def create
    if params[:upload]
      @contents = params[:upload].read
    elsif params[:text]
      @contents = params[:text]
    end
    render :action => 'show', :layout => false
  end

end
