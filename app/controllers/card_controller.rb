class CardController < ApplicationController

  require "payjp"
  before_action :set_card

  def new 
    card = Card.where(user_id: current_user.id).first
    redirect_to action: "index" if card.present?
  end

  def create 
    Payjp.api_key = "#{Rails.application.credentials.PAYJP_PRIVATE_KEY}"

    if params['payjp-token'].blank?
      redirect_to action: "new"
    else
      customer = Payjp::Customer.create(
      card: params['payjp-token'], 
        
      )
      @card = Card.new(user_id: current_user.id, customer_id: customer.id, card_id: customer.default_card)
      if @card.save
        redirect_to action: "index"
      else
        redirect_to action: "create"
      end
    end
  end


  def index
    if @card.present?
      Payjp.api_key = "#{Rails.application.credentials.PAYJP_PRIVATE_KEY}"
      customer = Payjp::Customer.retrieve(@card.customer_id)
      @card_information = customer.cards.retrieve(@card.card_id)

      @card_brand = @card_information.brand      
      case @card_brand
      when "Visa"
        @card_src = "https://pcweb-assets.mercdn.net/assets/img/card/visa.svg?3237555052"
      when "JCB"
        @card_src = "https://pcweb-assets.mercdn.net/assets/img/card/jcb.svg?3237555052"
      when "MasterCard"
        @card_src = "https://pcweb-assets.mercdn.net/assets/img/card/master-card.svg?3237555052"
      when "American Express"
        @card_src = "https://pcweb-assets.mercdn.net/assets/img/card/american_express.svg?3237555052"
      when "Diners Club"
        @card_src = "https://pcweb-assets.mercdn.net/assets/img/card/dinersclub.svg?3237555052"
      when "Discover"
        @card_src = "https://pcweb-assets.mercdn.net/assets/img/card/discover.svg?3237555052"
      end
    end
  end

  #def purchase
    #Payjp.api_key = "#{Rails.application.credentials.PAYJP_PRIVATE_KEY}"
    #Payjp::Charge.create(
      #amount: , # 購入金額
      #card: params['payjp-token'],
      #currency: 'jpy'
    #)
  #end

  def destroy 
    Payjp.api_key = "#{Rails.application.credentials.PAYJP_PRIVATE_KEY}"
    customer = Payjp::Customer.retrieve(@card.customer_id)
    customer.delete
    if @card.destroy 
      redirect_to action: "index", notice: "削除しました"
    else 
      redirect_to action: "index", alert: "削除できませんでした"
    end
  end


  private

  def set_card
    @card = Card.where(user_id: current_user.id).first if Card.where(user_id: current_user.id).present?
  end

end
  

