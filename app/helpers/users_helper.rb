module UsersHelper
  def user_initials(user)
    initials = user.name.to_s.split.first(2).map { |part| part[0] }.join.upcase
    initials.presence || "?"
  end
end
