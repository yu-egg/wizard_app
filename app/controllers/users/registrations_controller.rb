# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  def new
    @user = User.new
  end

  def create
    @user = User.new(sign_up_params)
      unless @user.valid?
        render :new and return
      end #まず、Userモデルのインスタンスを生成し、1ページ目から送られてきたパラメーターをインスタンス変数@userに代入します。そのインスタンス変数に対してvalid?メソッドを適用することで送られてきたパラメータが指定されたバリデーションに違反しないかどうかチェックすることができます。falseになった場合は、newアクションへrenderします。
    session["devise.regist_data"] = {user: @user.attributes}
    session["devise.regist_data"][:user]["password"] = params[:user][:password] #最後のページまで遷移した後に保存させる為に、sessionを用います。1ページ目で入力した情報のバリデーションチェックが完了したらsession["devise.regist_data"]に値を代入します。この時、sessionにハッシュオブジェクトの形で情報を保持させるために、attributesメソッドを用いてデータを整形しています。また、paramsの中にはパスワードの情報は含まれていますが、attributesメソッドでデータ整形をした際にパスワードの情報は含まれていません。そこで、パスワードを再度sessionに代入する必要があります。
    @address = @user.build_address
    render :new_address #次のページでは、このユーザーモデルに紐づく住所情報を入力させるため、該当するインスタンスを生成しておく必要があります。そのために、build_addressで今回生成したインスタンス@userに紐づくAddressモデルのインスタンスを生成します。ここで生成したAddressモデルのインスタンスは、@addressというインスタンス変数に代入します。そして、住所情報を登録させるページを表示するnew_addressアクションのビューへrenderします。
  end

  def create_address
    @user = User.new(session["devise.regist_data"]["user"])
    @address = Address.new(address_params)
      unless @address.valid? #2ページ目で入力した住所情報のバリデーションチェック
        render :new_address
      end
    @user.build_address(@address.attributes)
    @user.save #バリデーションチェックが完了した情報とsessionで保持していた情報を合わせ、ユーザー情報として保存
    session["devise.regist_data"]["user"].clear #sessionを削除する,clearメソッドを用いて明示的にsessionを削除します。
    sign_in(:user, @user) #ログインをする
  end

  private

  def address_params
    params.require(:address).permit(:postal_code, :address)
  end
  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
# 1行目のクラス名をみると、Devise::RegistrationsControllerを継承していることが分かります。そして、コメントアウトしている箇所はすでにDevise::RegistrationsControllerで定義されているものです。
# users/registrations_controller.rbに同名のメソッドを定義することによって、コメントアウト部分を上書きすることができます。deviseの機能を継承しているので、定義されているメソッドの中のsuperは、deviseで使用できるメソッドをそのまま実行することが出来ます。