class CommentsController < ApplicationController
  before_action :set_event, only: %i[create destroy]
  before_action :set_comment, only: %i[destroy]
  after_action :verify_authorized, only: %i[create destroy]

  def create
    @new_comment = @event.comments.build(comment_params)
    @new_comment.user = current_user

    authorize @new_comment

    if @new_comment.save
      notify_subscibers(@event, @new_comment)
      redirect_to @event, notice: I18n.t('controllers.comments.created')
    else
      render 'events/show', alert: I18n.t('controllers.comments.error')
    end
  end

  def destroy
    message = { notice: I18n.t('controllers.comments.destroyed') }

    authorize @comment

    @comment.destroy!

    redirect_to @event, message
  end

  private

  def set_comment
    @comment = @event.comments.find(params[:id])
  end

  def set_event
    @event = Event.find(params[:event_id])
  end

  def comment_params
    params.require(:comment).permit(:user_name, :body)
  end

  def notify_subscibers(event, comment)
    all_emails = event.subscriptions.map(&:user_email) + [event.user.email] - [comment.user&.email]

    all_emails.each { |email| EventMailer.comment(event, comment, email).deliver_now }
  end
end
