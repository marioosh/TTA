require 'digest/sha1'
class User < ActiveRecord::Base
  has_many :user_properties
  has_many :addresses, :dependent => :destroy

  has_and_belongs_to_many :groups
  belongs_to :profile
  
  # Virtual attribute for the unencrypted password plus some others
  attr_accessor :password, :remember_me, :iagree

  validates_uniqueness_of   :login,
                            :case_sensitive => false,
                            :message => 'Adres {{value}} jest już zarejestrowany.'
  validates_format_of       :login,
                            :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i,
                            :message => 'Wpisz prawidłowy adres e-mail.'
  validates_length_of       :password,
                            :within => 4..40,
                            :if => :password_required?,
                            :message => 'Wpisz hasło (minimum 4 znaki).'
  validates_length_of       :password_confirmation,
                            :within => 4..40,
                            :if => :password_required?,
                            :message => 'Wpisz hasło dwukrotnie.',
                            :presence => :true
  validates_confirmation_of :password,
                            :if => :password_required?,
                            :message => 'Wpisane hasło i jego powtórzenie nie zgadzają się.'
  
  validates_associated	:profile, :presence => true, :message => ''
  
  before_save :save_profile, :encrypt_password

  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :password, :password_confirmation, :remember_me, :iagree

  has_many :players
  has_many :games, :through => :players

  def has_privilege?(privilege)
    !privileges.index(privilege).nil?
  end
  
  def privileges
    prv = []
    self.groups.each do |group|
      group.privileges.each { |p| prv << p }
    end

    prv.uniq!
    return prv
  end

  # Activates the user in the database.
  def activate
    @activated = true
    self.active = true
    save(false)
  end

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(login, password)
    u = find :first, :conditions => { :login => login } # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end
  
  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  def self.find_by_remember_token(token)
    _id, _pass = token.split(/\./)
    begin
      _user = User.find(_id) if _id
      return _user if _user && _user.crypted_password[0,10] == _pass
    rescue ActiveRecord::RecordNotFound => e
      return false
    end
  end

  def remember_token?
    true
  end

  def remember_token
    "#{id}.#{crypted_password[0,10]}"
  end

  def remember_token_expires_at
    1.year.from_now.utc
  end

  def forget_me
  end

  # Returns true if the user has just been activated.
  def recently_activated?
    @activated
  end

  # Login is always e-mail address
  def email(full = false)
    full ? "#{self.profile.name} <#{self.login}>" : self.login
  end

  protected
    def save_profile
      self.profile.save unless self.profile.nil?
    end
    
    def encrypt_password
      return if password.blank?
      self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
      self.crypted_password = encrypt(password)
    end
      
    def password_required?
      crypted_password.blank? || !password.blank?
    end
end