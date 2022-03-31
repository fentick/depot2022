module StoreIndexCount
#    private

  def store_index_count
    if session[:counter].nil?
      session[:counter] = 1
      @time = 'time'
      @visit = 'Visit'
    elsif session[:counter] < 5
      session[:counter] += 1
      @time = 'time'.pluralize
      @visit = 'Visit'
    else
      session[:counter] += 1
      @time = ''
      @visit = ''
    end      
  end

  def store_index_reset
    session[:counter] = nil
  end

end