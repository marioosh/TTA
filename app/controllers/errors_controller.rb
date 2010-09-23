class ErrorsController < ApplicationController
  def missing
    render_404
  end
  
  def internal
    render_500
  end
  
  def maintenance
    render_503
  end
end
