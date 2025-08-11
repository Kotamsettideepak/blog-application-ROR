class BlogPolicy < ApplicationPolicy
  def update?
   user == record.user || user.role == "ADMIN"
  end

  def destroy?
    user == record.user || user.role == "ADMIN"
  end
end
