class Tagtask < ApplicationRecord
  belongs_to :task
  belongs_to :tag
  validates :tag_id, uniqueness: { scope: :task_id } # 同じペアは一つだけにする
end
