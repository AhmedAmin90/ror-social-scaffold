module UsersHelper
  def user_gravatar(user)
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    gravatar_url = "http://secure.gravatar.com/avatar/#{gravatar_id}"
    image_tag(gravatar_url, alt: user.name)
  end

  def my_see_link(user)
    if user == current_user
      link_to 'My Profile', user_path(user), class: 'profile-link'
    else
      link_to 'See Profile', user_path(user), class: 'profile-link'
    end
  end

  def aivable_friend(user)
    Friend.where('(user_id = ? and friend_id = ?) OR (user_id = ? and friend_id = ?)', current_user.id, user.id,
                 user.id, current_user.id).first
  end

  def friends_posts(user)
    render @posts if current_user.friends_list.include?(user)
  end

  def create_friend(user)
    return unless user != current_user
    return unless aivable_friend(user).nil?

    content_tag(:div, (button_to 'Add',
                                 friends_path(params: { friend: { user_id: user.id, friend_id: current_user.id } }),
                                 method: :post, class: 'button-add'), class: 'button-add')
  end

  def pending_friends()
    list = '<h3> Waiting List </h3>'
    if @user == current_user

      list += '<ul>'
      @user.pending_friendships.each do |watining_friends|
        list += user_gravatar(watining_friends.friend)
        list += "<li> <p> #{link_to watining_friends.friend.name,
                                    user_path(watining_friends.friend.id)} </p></li>"
        list += "<li> <p> <i class='fas fa-user-check'></i> #{link_to 'Accept', friend_path(watining_friends.id),
                                                                      method: :put} </p> </li>"
        list += "<li> <p> <i class='fas fa-user-times'></i> #{link_to 'Reject', friend_path(watining_friends.id),
                                                                      method: :delete} </p> </li>"
      end
      list += '</ul>'
    end

    list.html_safe
  end

  def friends_list()
    list = '<h3> Your Friends</h3>'

    if @user == current_user

      list += '<ul>'
      list += '<div class=friend-list>'
      @user.confirmed_friends&.each do |f|
        list += '<div>'
        list += user_gravatar(f.friend)

        list += "<li> <p> #{link_to f.friend.name, user_path(f.friend.id)} </p></li>"
        list += "<li> <p> #{link_to 'Unfriend', friend_path(f.id), method: :delete,
                                                                   data: { confirm: 'Are you sure? ' }} </p> </li>"

        list += '</div>'
      end

    end
    list += '</div>'
    list += '</ul>'

    list.html_safe
  end

  def user_posts
    list = current_user.confirmed_friends.map { |f| f.friend.id if f.status == true }
    list + [current_user.id]
  end
end
