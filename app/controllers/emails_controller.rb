class EmailsController < ApplicationController
  before_action :set_user, only: %i[edit update]

  def edit; end

  def update
    # 新しいメールアドレスをnew_emailカラムに一旦保存
    if @user.update(new_email_params)
      UserMailer.email_reconfirmation(@user).deliver_later
      redirect_to email_change_confirmation_path
    else
      flash.now[:alert] = t('emails.edit.not_edited')
      render :edit, status: :unprocessable_entity
    end
  end

  def confirm_email
    token_user = User.find_by(email_change_token: params[:token])

    unless token_user&.email_change_token_valid?
      redirect_to root_path, alert: t('emails.edit.invalid_token')
      return
    end

    # ユーザーがメールアドレス確認メールのリンクを開くとemailを更新する
    if token_user.update(email: token_user.new_email, new_email: nil, email_change_token: nil)
      redirect_to login_path, notice: t('emails.edit.edit')
    else
      redirect_to root_path, alert: t('emails.edit.not_edited')
    end
  end

  private

  def set_user
    @user = current_user
  end

  def new_email_params
    params.require(:user).permit(:new_email)
  end
end
