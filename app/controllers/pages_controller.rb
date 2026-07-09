class PagesController < ApplicationController
  allow_unauthenticated_access only: %i[ terms privacy ]

  def terms
  end

  def privacy
  end
end
