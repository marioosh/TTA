class Mailer < ActionMailer::Base
  default :from => "DEVEL <devel@rebel.pl>"

  def reset_password(recipient)
    @user = recipient

    mail(:to => recipient.email(true),
         :subject => "Odzyskiwanie hasła TEST",
         'X-Mailer' => 'REBEL.pl/TTA')
  end
end