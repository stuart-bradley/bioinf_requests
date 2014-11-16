class User < ActiveRecord::Base
before_validation :downcase_login

def downcase_login
  self.login = login.downcase
end

def email 
  self.login + "@lanzatech.com"
end

def get_name 
  self.login.sub('.', ' ').split.map(&:capitalize).join(' ')
end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :ldap_authenticatable, :rememberable, :trackable
end
