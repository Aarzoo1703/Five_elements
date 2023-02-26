class GalleryController < ApplicationController
  def index
    @products = Store.paginate(page: params[:page] ,per_page: 4)
  end
  def checkout
    amount_to_charge = session[:amount].to_i
     if request.post?
        ActiveMerchant::Billing::Base.mode = :test
         credit_card = ActiveMerchant::Billing::CreditCard.new(
            :first_name => params[:first_name],
            :last_name => params[:last_name],
            :number => params[:credit_no].to_i,
            :month => params[:check][:month].to_i,
            :year => params[:check][:year].to_i,
            :verification_value => params[:verification_number].to_i)
            gateway =ActiveMerchant::Billing::TrustCommerceGateway.new(
              :login => 'TestMerchant',
              :password =>'password',
              :test => 'true' )
              response = gateway.authorize(amount_to_charge , credit_card)
              #response = gateway.purchase(amount_to_charge, credit_card)    
             puts response.inspect
             if response.success?
              gateway.capture(amount_to_charge, response.authorization)
              #UserNotifier.purchase_complete(session[:user],current_cart).deliver        
              flash[:notice]="Thank You for using Five Elements.Order successfully placed!! The order details are sent to your mail"
               session[:cart_id]=nil
                session[:amount]=nil
                redirect_to :action=>:index
             else
                   flash[:notice]= "Something went wrong.Try again"
                   render :action => "checkout"
             end
     end
  end

  def search
    if request.post?
      keyword = '%'+params[:keyword].capitalize()+'%'
      @products = Store.where("name LIKE :k or  category LIKE :k or description LIKE :k ", k:"#{keyword}")
  
    end
    end
end