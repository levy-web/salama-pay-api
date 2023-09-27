class User < ApplicationRecord

    validates :email, presence: true, uniqueness: true
    # validate :phone_uniqueness_on_update, on: :update    
    validates :email, format: { with: URI::MailTo::EMAIL_REGEXP}
    validates :password, length: {minimum: 6}, on: :create

    has_secure_password
    has_one :account
    has_one :held_fund
    has_many :sent_transactions, class_name: 'Transaction', foreign_key: 'user_id'
    has_many :received_transactions, class_name: 'Transaction', foreign_key: 'opposite_user_id'
    has_many :pending_buyer_transactions, class_name: 'PendingSellerTransaction', foreign_key: 'user_id'
    has_many :pending_seller_transactions, class_name: 'PendingSellerTransaction', foreign_key: 'opposite_user_id'

    has_one_attached :id_front
    has_one_attached :id_back
    has_one_attached :profile_pic

    def id_front_url
        Rails.application.routes.url_helpers.url_for(id_front) if id_front.attached?
    end
    
    def id_back_url
        Rails.application.routes.url_helpers.url_for(id_back) if id_back.attached?
    end
    
    def profile_pic_url
        Rails.application.routes.url_helpers.url_for(profile_pic) if profile_pic.attached?
    end

    validates :verification_code, length: { is: 6 }, numericality: { only_integer: true }, allow_blank: true

    private

    def phone_uniqueness_on_update
        # Check phone uniqueness only during update
        if self.class.exists?(phone: phone)
            errors.add(:phone, 'has already been taken')
        end
    end

end
