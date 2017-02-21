class FxesController < ApplicationController
  
  def show
    @fxes = Fxes.all.by_name
  end
  
  def update
  end

  def destroy
  end
  
  
  
  
end
