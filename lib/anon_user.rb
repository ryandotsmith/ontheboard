
module  AnonUser
  
  class Anon
    ####################
    #has_role? should get
    #=>
    # and should return
    #=>
    def has_role?( user, object )
      false
    end
  end#end class AnonUser
  
  
  ####################
  #get_anon_user should get
  #=>
  # and should return
  #=>
  def get_anon_user
    Anon.new
  end
end