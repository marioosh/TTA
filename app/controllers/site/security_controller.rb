# This controller handles the login/logout function of the site.
class Site::SecurityController < Site::DefaultController
  def login
    if request.post?
      self.current_user = User.authenticate(params[:user][:login], params[:user][:password])

      if logged_in?
        if params[:user][:remember_me] == "1"
          cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
        end

        flash[:success] = "Zostałeś zalogowany jako <strong>#{self.current_user.login}</strong>.".html_safe
        redirect_back_or_default('/')
      else
        @user = User.new(params[:user])
        @user.errors.add(:password, "Wpisz hasło.") if @user.password.blank?
        @user.errors.add(:login, "Podaj adres e-mail.") if @user.login.blank?

        if @user.errors.count == 0
          if User.find_by_login @user.login
            @user.errors.add(:password, "Nieprawidłowe hasło.")
          else
            @user.errors.add(:login, "Nie istnieje użytkownik o adresie e-mail #{@user.login}.")
          end
        end
      end
    else
      @user = User.new(:login => 'XX')
      @user.remember_me = "1"
    end
  end

  def password
    @user = User.new(params[:user])
    if request.post? && params[:user]
      if @user.login.blank?
        @user.errors.add(:login, "Wpisz adres e-mail.")
      else
        user = User.find_by_login @user.login
        if user.nil?
          @user.errors.add(:login, "Nie istnieje użytkownik o adresie e-mail #{@user.login}.")
        else
          Mailer.reset_password(user).deliver
          flash[:success] = "Na adres <strong>#{user.login}</strong> została wysłana wiadomość z informacją o ustawieniu nowego hasła. Jeżeli nie otrzymasz tej wiadomości w ciągu kilku minut, sprawdź folder SPAM lub skontaktu się z nami.".html_safe
          redirect_to :action => 'login'
        end
      end
    end
  end

  def activate
    
  end

  def register
    if request.post?
      @user = User.new(params[:user])
      @profile = @user.build_profile(params[:profile])

      @user.errors.add(:iagree, "Musisz zaakceptować regulamin.") unless @user.iagree == '1'
      if @user.save
        @user.groups << Group.find_by_name('Użytkownicy')
        self.current_user = User.authenticate(params[:user][:login], params[:user][:password])
        flash[:success] = "Konto <strong>#{self.current_user.login}</strong> zostało utworzone."
        redirect_back_or_default('/')
      end
    else
      @user = User.new
      @profile = @user.build_profile
    end
  end
  
  def logout
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session

    flash[:notice] = "Zostałeś wylogowany."
    redirect_back_or_default('/')
  end
end