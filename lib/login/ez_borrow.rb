module Login
  class EZBorrow
    BOR_STATUSES = %w(
      20 21 22 23 50 51 52 53 54 55 56 57 58 60 61
      62 63 65 66 80 81 82 30 31 32 33 34 35 36 37
      38 39 40 41
    ).to_set.freeze

    def initialize(user)
      @user = user
    end

    # Send all missing methods to @user instance.
    # Makes EZBorrow a psuedochild of User
    def method_missing(meth, *args, &blk)
      @user.public_send(meth, *args, &blk)
    end

    # Adds all aleph_properties as methods directly callable on the instance
    Login::Aleph::Patron::PATRON_PROPERTIES.each do |prop|
      define_method(prop) { aleph_properties[prop] }
    end

    def authorized?
      patron_status.present? && BOR_STATUSES.include?(patron_status)
    end
  end
end
