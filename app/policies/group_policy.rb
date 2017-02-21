class GroupPolicy
  attr_reader :user, :group

  def initialize(user, group)
    @user = user
    @group = group
  end

  def index?
    view?
  end

  def new?
    view?
  end

  def create?
    view?
  end

  def show?
    view?
  end

  def edit?
    view?
  end
  def update?
    view?
  end

  def destroy?
    view?
  end

  def view?
    user.group_user && user.group_user.approved? && user.group == group
  end

end
