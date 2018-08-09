module Login
  class EZBorrow
    EZBORROW_BOR_STATUSES =
      %w(20 21 22 23 50 51 52 53 54 55 56 57 58 60 61 62 63 65 66 80 81 82 30 31 32 33 34 35 36 37 38 39 40 41)
        .to_set
        .freeze

    EZBORROW_UNAUTHORIZED_REDIRECT = "https://library.nyu.edu/errors/ezborrow-library-nyu-edu/unauthorized"
      EZBORROW_URL_BASE = "https://e-zborrow.relaisd2d.com/service-proxy/"

    def self.url_base
      EZBORROW_URL_BASE
    end

    def self.unauthorized_url
      EZBORROW_UNAUTHORIZED_REDIRECT
    end

    attr_reader :user

    def initialize(user)
      @user = user
    end

    def authorized?
      patron_status = user.aleph_properties[:patron_status]
      patron_status.present? && EZBORROW_BOR_STATUSES.include?(patron_status)
    end

    def barcode
      user.aleph_properties[:barcode]
    end

  end
end
