# frozen_string_literal: true

class Tag < ApplicationRecord
  has_many :tagtasks
  has_many :tasks, through: :tagtasks
end
