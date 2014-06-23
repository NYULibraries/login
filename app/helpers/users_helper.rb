module UsersHelper
  # This redefines user_url for a User object, which is not identified as a resource
  # Essentially fakes a resource URL
  def user_url(*args)
    if(args.first.is_a?(User))
      user = args.shift
      super(user.provider, user.username, *args)
    else
      super
    end
  end
end
