class EmailsController < ApplicationController
  before_action :set_user, only: %i[edit update]

  def edit; end

  def update
    if @user.update(new_email_params)
      UserMailer.email_reconfirmation(@user).deliver_later
      redirect_to email_change_confirmation_path
    else
      render :edit, status: :unprocessable_entity, alert: t('emails.edit.not_edited')
    end
  end

  def confirm_email
    token_user = User.find_by(confirmation_token: params[:token])

    if token_user&.confirmation_token_expires?
      if token_user.update(email: token_user.new_email, new_email: nil, confirmation_token: nil)
        redirect_to login_path, notice: t('emails.edit.edit')
      else
        redirect_to root_path, alert: t('emails.edit.not_edited')
      end
    else
      redirect_to root_path, alert: t('emails.edit.invalid_token')
    end
  end

  private

  def set_user
    @user = current_user
  end

  def new_email_params
    params.require(:user).permit(:new_email)
  end

  def confirmation_token_expires?
    @user.confirmation_sent_at >= 2.hours.ago
  end
end
