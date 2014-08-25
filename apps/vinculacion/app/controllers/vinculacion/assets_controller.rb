require_dependency "vinculacion/application_controller"

module Vinculacion
  class AssetsController < ApplicationController
    before_filter :auth_required
  	def index
  	end
  end
end
