class SubscriptionsController < ApplicationController
  before_action :set_event, only: %i[create destroy]
  before_action :set_subscription, only: %i[destroy]
  after_action :verify_authorized, only: %i[create destroy]

  def create
    @new_subscription = @event.subscriptions.build(subscription_params)
    @new_subscription.user = current_user

    authorize @new_subscription

    if @new_subscription.save
      EventMailer.subscription(@event, @new_subscription).deliver_now
      redirect_to @event, notice: I18n.t('controllers.subscription.created')
    else
      render 'events/show', alert: I18n.t('controllers.susbscription.error')
    end
  rescue Pundit::NotAuthorizedError
    redirect_to root_path, alert: I18n.t('pundit.not_authorized')
  end

  def destroy
    message = { notice: I18n.t('controllers.subscription.destroyed') }

    authorize @subscription

    @subscription.destroy!

    redirect_to @event, message
  rescue Pundit::NotAuthorizedError
    redirect_to @event, alert: I18n.t('pundit.not_authorized')
  end

  private

  def set_subscription
    @subscription = @event.subscriptions.find(params[:id])
  end

  def set_event
    @event = Event.find(params[:event_id])
  end

  def subscription_params
    params.fetch(:subscription, {}).permit(:user_email, :user_name)
  end
end
