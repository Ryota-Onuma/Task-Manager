# frozen_string_literal: true

class User < ApplicationRecord
  before_save { self.email = email.downcase } # メールアドレスは大文字・小文字を区別しないので、データベースに登録前に小文字に戻す
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze

  has_many :tasks, dependent: :destroy

  validates :name, presence: true, length: { maximum: 20 } # 名前は１文字以上20文字以下
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false } # uniqueness:{ case_sensitive: false }で、メールアドレスのバリデーションで、大文字・小文字の区別を無くしている　
  validates :password_digest, presence: true
  validates :introduction, length: { maximum: 150 }
  validates :permission, inclusion: { in: [true, false] }
  validates :admin, inclusion: { in: [true, false] }
end
