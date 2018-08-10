module Users
  module EZBorrow
    UNAUTHORIZED_REDIRECT = <<~HEREDOC.freeze
      https://library.nyu.edu/errors/ezborrow-library-nyu-edu/unauthorized
    HEREDOC

    URL_BASE = "https://e-zborrow.relaisd2d.com/service-proxy/".freeze
    AUTHORIZED_INSTITUTIONS = %w(nyu nyush nyuad).freeze

    def self.included(base)
      base.prepend_before_action :verify_institution, raise: false
    end

    def ezborrow
      ezborrow_user = Login::EZBorrow.new(current_user)
      barcode = ezborrow_user.barcode
      if ezborrow_user.authorized? && barcode.present?
        ls = params[:ls].present? ? params[:ls] : 'NYU'
        query = params[:query].present? ? CGI::escape(params[:query]) : ''
        redirect_to "#{URL_BASE}?command=mkauth&LS=#{ls}&PI=#{barcode}&query=#{query}"
      else
        redirect_to UNAUTHORIZED_REDIRECT
      end
    end

    def verify_institution
      if invalid_institution?
        flash[:alert] = <<~HEREDOC.squeeze
          EZBorrow priviledges are only eligible to eligible NYU borrowers.
          Please log in to confirm your EZBorrow priviledge eligibility.
        HEREDOC
        redirect_to login_path('nyu')
      end
    end
    private :verify_institution

    def invalid_institution?
      AUTHORIZED_INSTITUTIONS.include?(params[:institution])
    end
    private :invalid_institution
  end
end
