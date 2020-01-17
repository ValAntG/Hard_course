class CommentPolicy < ApplicationPolicy
  def index?
    true
  end

  def create?
    user.present?
  end

  def update?
    return true if user.present? && user == comment.user
  end

  def destroy?
    return true if user.present? && user == comment.user
  end

  private

  def comment
    record
  end
end
