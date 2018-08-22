module Users
  module EZBorrowLogin
    UNAUTHORIZED_REDIRECT = "https://library.nyu.edu/errors/ezborrow-library-nyu-edu/unauthorized".freeze
    URL_BASE = "https://e-zborrow.relaisd2d.com/service-proxy/".freeze
    AUTHORIZED_INSTITUTIONS = %w(nyu nyush nyuad).freeze

    def self.included(base)
      base.prepend_before_action :require_login_ezborrow, only: [:ezborrow_login]
    end

    def require_login_ezborrow
      unless user_signed_in?
        redirect_to login_path_ezborrow
      end
    end

    def ezborrow_user
      @ezborrow_user ||= Login::EZBorrow.new(current_user)
    end

    def ezborrow_login
      if ezborrow_user.authorized?
        redirect_to ezborrow_redirect
      else
        redirect_to UNAUTHORIZED_REDIRECT
      end
    end

    private

    def institution
      institution = current_institution.code.downcase.to_s
      AUTHORIZED_INSTITUTIONS.include?(institution) ? institution : 'nyu'
    end

    def login_path_ezborrow
      login_url institution: institution, referrer: 'ezborrow'
    end

    def ezborrow_redirect
      identifier = ezborrow_user.identifier
      ls = institution.upcase
      if params[:query]
        query = CGI.escape(params[:query])
        "#{URL_BASE}?command=mkauth&LS=#{ls}&PI=#{identifier}&query=#{query}"
      else
        'https://e-zborrow.relaisd2d.com/index.html'
      end
    end
  end
end
