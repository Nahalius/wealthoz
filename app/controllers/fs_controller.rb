class FsController < ApplicationController
  
  def show
    @fs = Fs.all.by_name
  end
  
  def update
  end

  def destroy
  end

end
