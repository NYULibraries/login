module Users
  module EZBorrow
    UNAUTHORIZED_REDIRECT = "https://library.nyu.edu/errors/ezborrow-library-nyu-edu/unauthorized".freeze
    URL_BASE = "https://e-zborrow.relaisd2d.com/service-proxy/".freeze

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
  end
end
