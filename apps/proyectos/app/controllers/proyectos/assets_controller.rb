require_dependency "proyectos/application_controller"

module Proyectos
  class AssetsController < ApplicationController

    before_filter :auth_required
    def index
    end

  end
end
