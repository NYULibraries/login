module Login
  class EZBorrow
    BOR_STATUSES =
      %w(20 21 22 23 50 51 52 53 54 55 56 57 58 60 61 62 63 65 66 80 81 82 30 31 32 33 34 35 36 37 38 39 40 41)
        .to_set
        .freeze

    attr_reader :user

    def initialize(user)
      @user = user
    end

    def authorized?
      patron_status = user.aleph_properties[:patron_status]
      patron_status.present? && BOR_STATUSES.include?(patron_status)
    end

    def barcode
      user.aleph_properties[:barcode]
    end
  end
end
