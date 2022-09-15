# Controller containing all logic for log in to EZBorrow through the login server.

# Strategy:
# 1. Users not logged in follow the require_login! path, to return back to the original request.fullpath
# 2. Users logged in are checked against the set of valid BOR_STATUSES
# - Valid users are redirected to EZBorrow, including the query if present in the original request
#   - EZBorrow redirect includes the users identifer and institution
# - Invalid users are redirected to UNAUTHORIZED_REDIRECT

module Users
  class EzBorrowLoginController < ApplicationController
    require 'addressable/template'

    UNAUTHORIZED_REDIRECT = "https://library.nyu.edu/errors/ezborrow-library-nyu-edu/unauthorized".freeze
    URL_BASE = "https://ezb.relaisd2d.com/".freeze
    LS_BY_INSTITUTION = {
      'nyu'    => 'NYU',
      'nyuad'  => 'NYU',
      'nyush'  => 'NYU',
      'hsl'    => 'NYU',
      'ns'     => 'THENEWSCHOOL',
    }.freeze
    SKINNED_EZB_INSTITUTIONS = LS_BY_INSTITUTION.keys.freeze
    BOR_STATUSES = %w(
      20 21 22 23 50 51 52 53 54 55 56 57 58 60 61
      62 63 65 66 80 81 82 30 31 32 33 34 35 36 37
      38 39 40 41
    ).to_set.freeze

    before_action :require_login!

    def ezborrow_login
      redirect_uri = ezborrow_user_authorized? ? ezborrow_redirect : UNAUTHORIZED_REDIRECT
      redirect_to redirect_uri
    end

    private

    def ezborrow_user
      @ezborrow_user = current_user
    end

    def ezborrow_user_authorized?
      patron_status = ezborrow_user.aleph_properties[:patron_status]
      BOR_STATUSES.include? patron_status
    end

    def ezborrow_user_institution
      institution_code = ezborrow_user.aleph_properties[:institution_code].downcase
      SKINNED_EZB_INSTITUTIONS.include?(institution_code) ? institution_code : 'nyu'
    end

    def ezborrow_redirect
      template = Addressable::Template.new("#{URL_BASE}{?LS,PI,query}")

      template.expand(
        query: params[:query],
        PI: ezborrow_user.aleph_properties[:identifier],
        LS: LS_BY_INSTITUTION[ezborrow_user_institution],
      ).to_s
    end
  end
end
