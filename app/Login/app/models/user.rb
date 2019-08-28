class User < ApplicationRecord
  validates :email, presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }
  validates :password, presence: true, length: { minimum: 8 }
  validates :name, presence: false, length: { minimum: 5 }, allow_blank: true
  before_save :fix_name, :downcase_email
  attr_accessor :remember_token, :activation_token, :reset_token
  before_create :create_remember_token
  before_create :create_activation_digest

  has_secure_password


  def self.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def self.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  # 引数のハッシュ値を返す
  def User.digest(token)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
               BCrypt::Engine.cost
    BCrypt::Password.create(token.to_s, cost: cost)
  end

  # ランダムトークン生成
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # パスワード再設定の属性を設定する
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest,  User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  # パスワード再設定のメールを送信する
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # トークンがダイジェストと一致したらtrueを返す
  # Userインスタンスのカラムを引数に指定し、返り値でカラムを返している。
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # パスワード再設定の期限が切れている場合はtrueを返す
  def password_reset_expired?
    reset_sent_at < 6.hours.ago
  end


  private
    # メールアドレスをすべて小文字にする
    def downcase_email
      self.email = email.downcase
    end

    # 有効化トークンとダイジェストを作成及び代入
    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end

    def fix_name
      if self.name==nil
        self.name = self.email.split('@').first
      end
    end

    def create_remember_token
      self.remember_token = User.digest(User.new_remember_token)
    end

    # アカウントを有効にする
    def activate
      update_attribute(:activated,    true)
      update_attribute(:activated_at, Time.zone.now)
    end

    # 有効化用のメールを送信する
    def send_activation_email
      UserMailer.account_activation(self).deliver_now
    end

end
