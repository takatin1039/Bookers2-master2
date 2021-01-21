class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
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
