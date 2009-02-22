# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper


  ####################
  #self.get_css should get
  #=>
  # and should return
  #=>
  def get_css
    [ 'std',
      'form',
      'list',
      'jquery.autocomplete',
      'jquery.lavalamp',
      'jquery_theme/ui.all.css']
  end
  def get_js
    [ :defaults, 
      'jquery.easing.js',
      'jquery.easing.min.js',
      'jquery.lavalamp.js',
      'jquery.corners.js',
      'autocomplete/jquery.autocomplete.js',
      'autocomplete/jquery.autocomplete.min.js',
      'autocomplete/jquery.autocomplete.pack.js']
  end

end
