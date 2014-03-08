module UsersHelper
  def header_link_to cname, aname, title, path
    if controller_name == cname and (aname.nil? or params[:action] == aname)
      content_tag :li, class: 'active' do
        link_to title, path
      end
    else
      content_tag :li do
        link_to title, path
      end
    end
  end
end
