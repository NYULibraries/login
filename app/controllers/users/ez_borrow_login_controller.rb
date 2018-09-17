module Users
  class EzBorrowLoginController < ApplicationController
    UNAUTHORIZED_REDIRECT = "https://library.nyu.edu/errors/ezborrow-library-nyu-edu/unauthorized".freeze
    URL_BASE = "https://e-zborrow.relaisd2d.com/service-proxy/".freeze
    LS_BY_INSTITUTION = {
      'nyu'    => 'NYU',
      'nyuad'  => 'NYU',
      'nyush'  => 'NYU',
      'ns'     => 'THENEWSCHOOL',
    }.freeze
    AUTHORIZED_INSTITUTIONS = LS_BY_INSTITUTION.keys.freeze
    BOR_STATUSES = %w(
      20 21 22 23 50 51 52 53 54 55 56 57 58 60 61
      62 63 65 66 80 81 82 30 31 32 33 34 35 36 37
      38 39 40 41
    ).to_set.freeze

    before_action :require_valid_institution!
    before_action :require_login!

    def ezborrow_login
      redirect_to ezborrow_user_authorized? ? ezborrow_redirect : UNAUTHORIZED_REDIRECT
    end

    private

    def require_valid_institution!
      redirect_to UNAUTHORIZED_REDIRECT unless valid_institution?
    end

    def valid_institution?
      AUTHORIZED_INSTITUTIONS.include? institution.code.downcase.to_s
    end

    def ezborrow_user
      @ezborrow_user = current_user
    end

    def ezborrow_user_authorized?
      patron_status = ezborrow_user.aleph_properties[:patron_status]
      BOR_STATUSES.include? patron_status
    end

    def ezborrow_user_institution
      institution_code = ezborrow_user.aleph_properties[:institution_code].downcase
      AUTHORIZED_INSTITUTIONS.include?(institution_code) ? institution_code : 'nyu'
    end

    def ezborrow_redirect
      query = params[:query] && CGI.escape(params[:query])
      identifier = ezborrow_user.aleph_properties[:identifier]
      ls = LS_BY_INSTITUTION[ezborrow_user_institution]
      "#{URL_BASE}?command=mkauth&LS=#{ls}&PI=#{identifier}&query=#{query}"
    end
  end
end
