class AnswerPolicy < ApplicationPolicy
  def index?
    true
  end

  def create?
    user.present?
  end

  def update?
    return true if user.present? && user == answer.user
  end

  def destroy?
    return true if user.present? && user == answer.user
  end

  private

  def answer
    record
  end
end
