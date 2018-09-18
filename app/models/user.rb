class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable


  def attempt_set_password(params)
  	p = {}
  	p[:password] = params[:password]
  	p[:password_confirmation] = params[:password_confirmation]
  	update_attributes(p)
  end

  def password_match?
  	self.errors[:password].push "can't be blank" if password.blank?
  	self.errors[:password_confirmation].push "can't be blank" if password_confirmation.blank?
  	self.errors[:password_confirmation].push "does not match password" if password != password_confirmation
  	password == password_confirmation && !password.blank?
  end

  # runs when password is blank
  def has_no_password?
  	self.encrypted_password.blank?
  end

  def only_if_unconfirmed
  	pending_any_confirmation { yield }
  end

  def password_required?
  	if !persisted?
  		false
  	else
  		!password.nil? || !password_confirmation.nil?
  	end
  end


end
