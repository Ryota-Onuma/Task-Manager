# frozen_string_literal: true

class Task < ApplicationRecord
  belongs_to :user
  has_many :tag_tasks, dependent: :destroy
  has_many :tags, through: :tag_tasks

  validates :title, presence: true, length: { maximum: 30 } # タイトルは１文字以上30文字以下
  validates :content, presence: true
  validates :status, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 3 } # statusは　１　＝　未着手　, 2 = 着手中　, ３　＝　履行済　なので、１、２、３以外は弾く
  validates :important,  presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 3 } # priortyは　１　＝　優先度高　, 2 = 優先度中　, ３　＝　優先度低　なので、１、２、３以外は弾く
end
