module Users
  module EZBorrowLogin
    UNAUTHORIZED_REDIRECT = "https://library.nyu.edu/errors/ezborrow-library-nyu-edu/unauthorized".freeze
    URL_BASE = "https://e-zborrow.relaisd2d.com/service-proxy/".freeze
    INSTITUTION_LS = {
      'nyu'    => 'NYU',
      'nyuad'  => 'NYU',
      'nyush'  => 'NYU',
      'ns'     => 'THENEWSCHOOL',
    }.freeze
    AUTHORIZED_INSTITUTIONS = INSTITUTION_LS.keys

    def ezborrow_login
      if ezborrow_user.authorized?
        redirect_to ezborrow_redirect
      else
        redirect_to UNAUTHORIZED_REDIRECT
      end
    end

    private

    def ezborrow_user
      @ezborrow_user ||= Login::EZBorrow.new(current_user)
    end

    def institution
      institution = ezborrow_user.aleph_properties[:institution_code].downcase
      AUTHORIZED_INSTITUTIONS.include?(institution) ? institution : 'nyu'
    end

    def ezborrow_redirect
      identifier = ezborrow_user.aleph_identifier
      ls = INSTITUTION_LS[institution]
      if params[:query]
        query = CGI.escape(params[:query])
        "#{URL_BASE}?command=mkauth&LS=#{ls}&PI=#{identifier}&query=#{query}"
      else
        'https://e-zborrow.relaisd2d.com/index.html'
      end
    end
  end
end
