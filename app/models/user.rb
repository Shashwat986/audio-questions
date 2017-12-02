class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :rememberable, :trackable, :validatable

  # Hacky fix for devise
  alias_attribute :email, :username

  def email_required?
    false
  end

  def email_changed?
    false
  end
end
