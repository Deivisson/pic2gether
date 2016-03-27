class User::OrdersController < User::BaseController
  before_action :set_order, only: [:index, :show]

	def index
		@orders = current_user.orders.order("created_at desc")
	end

	def show
		@callback_provider = params["provider"].present?
    puts @callback_provider
	end

	def create
		plan = WorkshopPlan.find(params[:plan_id])
    unless plan.nil?
      description = "Gerenciamento Workshop - Plano #{plan.description}"
      attributes = {
        description: description ,
        origin:Order::ORIGIN_WORKSHOP,
        type_of:Pagseguro::PAYMENTS,
        workshop_plan_id:plan.id
      }
      @order = current_user.orders.build(attributes)
      if @order.save
        payment 								 = PagSeguro::PaymentRequest.new
        payment.reference 			 = @order.id
        payment.notification_url = api_v1_pagseguro_notifications_url
        payment.redirect_url 		 = user_order_url(id:@order.id,provider:"pagseguro")

        payment.items << {
          id: plan.id,description:description,amount: plan.value
        }
        response = payment.register
        if response.errors.any?
          raise response.errors.join("\n")
        else
          redirect_to response.url
        end
      end
    end		
	end

private
  def set_order
    if params[:id]
      @order = current_user.orders.find(params[:id]) 
    else
      @order = current_user.orders.last
    end
  end
end
