# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper


  ####################
  #self.get_css should get
  #=>
  # and should return
  #=>
  def get_css
    ['std','form','list','jquery.autocomplete']
  end
  def get_js
    [ :defaults, 
      'autocomplete/jquery.autocomplete.js',
      'autocomplete/jquery.autocomplete.min.js',
      'autocomplete/jquery.autocomplete.pack.js']
  end

end
