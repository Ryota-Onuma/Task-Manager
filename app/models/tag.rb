# frozen_string_literal: true

class Tag < ApplicationRecord
  has_many :tag_tasks
  has_many :tasks, through: :tag_tasks
end
