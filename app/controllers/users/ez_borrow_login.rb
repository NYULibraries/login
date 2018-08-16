module Users
  module EZBorrowLogin
    UNAUTHORIZED_REDIRECT = "https://library.nyu.edu/errors/ezborrow-library-nyu-edu/unauthorized".freeze
    URL_BASE = "https://e-zborrow.relaisd2d.com/service-proxy/".freeze
    AUTHORIZED_INSTITUTIONS = %w(nyu nyush nyuad).freeze

    def self.included(base)
      base.prepend_before_action :verify_institution, only: [:ezborrow_login]
      base.prepend_before_action :require_login_ezborrow, only: [:ezborrow_login]
    end

    def require_login_ezborrow
      unless user_signed_in?
        redirect_to login_path_ezborrow
      end
    end

    def ezborrow_login
      ezborrow_user = Login::EZBorrow.new(current_user)
      if ezborrow_user.authorized?
        redirect_to ezborrow_redirect(ezborrow_user)
      else
        redirect_to UNAUTHORIZED_REDIRECT
      end
    end

    private

    def verify_institution
      if invalid_institution?
        redirect_to login_path_ezborrow
      end
    end

    def invalid_institution?
      !AUTHORIZED_INSTITUTIONS.include?(params[:institution])
    end

    def login_path_ezborrow
      login_url institution: 'nyu', referrer: 'ezborrow'
    end

    def ezborrow_redirect(ezborrow_user)
      identifier = ezborrow_user.identifier
      ls = current_institution.code.upcase || 'NYU'
      if params[:query]
        "#{URL_BASE}?command=mkauth&LS=#{ls}&PI=#{identifier}&query=#{query}"
      else
        "https://e-zborrow.relaisd2d.com/index.html"
      end
    end
  end
end
