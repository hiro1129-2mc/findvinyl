class EmailsController < ApplicationController
  before_action :set_user, only: %i[edit update]

  def edit; end

  def update
    # 新しいメールアドレスをnew_emailカラムに一旦保存
    if @user.update(new_email_params)
      UserMailer.email_reconfirmation(@user).deliver_later
      redirect_to email_change_confirmation_path
    else
      flash.now[:alert] = t('.failure')
      render :edit, status: :unprocessable_entity
    end
  end

  def confirm_email
    token_user = User.find_by(confirmation_token: params[:token])

    unless token_user&.confirmation_token_valid?
      redirect_to root_path, alert: t('.invalid_token')
      return
    end

    # ユーザーがメールアドレス確認メールのリンクを開くとemailを更新する
    if token_user.update(email: token_user.new_email, new_email: nil, confirmation_token: nil)
      logout
      redirect_to login_path, notice: t('.success')
    else
      redirect_to root_path, alert: t('.failure')
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
