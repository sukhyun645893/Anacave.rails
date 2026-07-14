class User < ApplicationRecord
  # 회원 계정입니다. 로그인은 이메일이 아니라 아이디(username)로 합니다.
  has_secure_password
  has_one_attached :avatar
  has_many :sessions, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :uploaded_images, dependent: :destroy
  has_many :security_events, dependent: :nullify
  has_many :post_votes, dependent: :destroy
  has_many :reports, dependent: :destroy
  has_many :anacons, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :user_anacons, dependent: :destroy
  has_many :downloaded_anacons, through: :user_anacons, source: :anacon

  normalizes :username, with: ->(value) { value.to_s.strip.downcase }
  normalizes :email_address, with: ->(value) { value.to_s.strip.downcase.presence }

  before_validation :set_default_nickname, if: -> { nickname.blank? && username.present? }

  validates :username,
    presence: true,
    uniqueness: true,
    length: { in: 3..24 },
    format: { with: /\A[a-z0-9_]+\z/, message: "은 영문 소문자, 숫자, 밑줄(_)만 사용할 수 있습니다." }
  validates :email_address, uniqueness: true, allow_blank: true
  validates :nickname, presence: true, uniqueness: true, length: { maximum: 30 }
  validates :bio, length: { maximum: 300 }
  validate :avatar_must_be_image

  # 화면에 표시할 이름입니다. 닉네임이 없으면 아이디를 대신 보여줍니다.
  def display_name
    nickname.presence || username
  end

  private
    # 가입할 때 닉네임을 비워두면 아이디로 자동 생성합니다.
    def set_default_nickname
      self.nickname = username
    end

    # 프로필 이미지는 이미지 파일만 허용하고, 너무 큰 파일은 막습니다.
    def avatar_must_be_image
      return unless avatar.attached?

      unless avatar.content_type.in?(%w[image/jpeg image/png image/gif image/webp])
        errors.add(:avatar, "이미지 파일만 사용할 수 있습니다.")
      end

      if avatar.blob.byte_size > 2.megabytes
        errors.add(:avatar, "2MB 이하 이미지만 사용할 수 있습니다.")
      end
    end
end
