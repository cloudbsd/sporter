module UsersHelper
  def header_link_to cname, aname, title, path
    if controller_name == cname and (aname.nil? or params[:action] == aname)
    # content_tag :li, class: 'active' do
      content_tag :li do
        link_to title, path
      end
    else
      content_tag :li do
        link_to title, path
      end
    end
  end

  def tab_link_to title, path, tab, cur_tab
    if cur_tab == tab
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
