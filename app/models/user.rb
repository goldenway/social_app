# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  email           :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  password_digest :string(255)
#  remember_token  :string(255)
#  admin           :boolean          default(FALSE)
#

class User < ActiveRecord::Base
	attr_accessible :name, :email, :password, :password_confirmation
	has_secure_password
	has_many :microposts, dependent: :destroy

	has_many :relationships, foreign_key: "follower_id", dependent: :destroy
	has_many :followed_users, through: :relationships, source: :followed
	# використовуємо source, бо ми назвали followed_users замість "followeds"
	# (від followed_id в таблиці relationships)

	has_many :reverse_relationships, foreign_key: "followed_id",
									 class_name: "Relationship",
									 dependent: :destroy
	has_many :followers, through: :reverse_relationships, source: :follower
	# можна без source, бо follower_id існує в таблиці reverse_relationships

	before_save { email.downcase! }
	# the same as:
	# before_save { |user| user.email = email.downcase }
	before_save :create_remember_token

	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :name,	 presence: true, length: { maximum: 50 }
	validates :email,	 presence: true, format: { with: VALID_EMAIL_REGEX },
						 uniqueness: { case_sensitive: false }
	validates :password, length: { minimum: 6 }
	validates :password_confirmation, presence: true

	def feed
		# Micropost.where("user_id = ?", id) # пости тільки самого current_user'a
		Micropost.from_users_followed_by(self) # пости юзера і всіх його followed users
	end

	def following?(other_user)
		relationships.find_by_followed_id(other_user.id)
	end

	def follow!(other_user)
		relationships.create!(followed_id: other_user.id)
		# the same as
		# self.relationships.create!(followed_id: other_user.id)
	end

	def unfollow!(other_user)
		relationships.find_by_followed_id(other_user.id).destroy
	end

	private

		def create_remember_token
			# SecureRandom.urlsafe_base64 возвращает случайную строку длиной в
			# 16 символов составленную из знаков A–Z, a–z, 0–9, “-” и “_”
			self.remember_token = SecureRandom.urlsafe_base64
		end
end
