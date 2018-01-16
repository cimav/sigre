# coding: utf-8
module Vinculacion
  class CimavNetmultixRecord < ActiveRecord::Base

  establish_connection :"#{Rails.env}_cimavnetmultix"

  self.abstract_class = true

  end
end