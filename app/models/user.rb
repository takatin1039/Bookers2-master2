class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
  has_many :books, dependent: :destroy
  attachment :profile_image
  validates :name, presence: true, length: { minimum: 2, maximum: 20}
  validates :introduction, length: { maximum: 50}
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy

  # foregin_key = 入口
  # source = 出口
  has_many :relationships
  has_many :followings, through: :relationships, source: :follow
  has_many :reverse_of_relationships, class_name: 'Relationship', foreign_key: 'follow_id'
  has_many :followers, through: :reverse_of_relationships, source: :user

  has_many :user_rooms, dependent: :destroy
  has_many :chats, dependent: :destroy

  #住所自動入力
  #都道府県コードから都道府県名に自動で変換する。
  include JpPrefecture
  jp_prefecture :prefecture_code

  #~.prefecture_nameで都道府県名を参照出来る様にする。
  #例) @user.prefecture_nameで該当ユーザーの住所(都道府県)を表示出来る
  def prefecrture_name
    JpPrefecture::Prefecture.find(code: prefecture_code).try(:name)
  end
  def prefecture_name=(prefecture_name)
    self.prefecture_code = JpPrefecture::Prefecture.find(name: prefecture_name).code
    
  end

  def follow(other_user)
    # フォローしようとしている other_user が自分自身ではないかを検証
    unless self == other_user
      # 見つかれば Relation を返し、見つからなければ self.relationships.create(follow_id: other_user.id)
      # としてフォロー関係を保存(create = new + save)することができます。これにより、既にフォローされている場合に
      # フォローが重複して保存されることがなくなります！
      self.relationships.find_or_create_by(follow_id: other_user.id)
    end
    
  end

  def unfollow(other_user)
    relationship = self.relationships.find_by(follow_id: other_user.id)
    relationship.destroy if relationship
    
  end

  def following?(other_user)
    self.followings.include?(other_user)
    
  end



end
