# frozen_string_literal: true

class Task < ApplicationRecord
  belongs_to :user
  has_many :tag_tasks, dependent: :destroy
  has_many :tags, through: :tag_tasks
end