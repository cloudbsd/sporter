module ApplicationHelper
  def flash_messages!
    html = ""
    flash.each do |name, msg|
      if msg.is_a? String
      # message = content_tag :div, msg, :id => "flash_#{name}"
        msgclass = "fade in alert alert-#{name == :notice ? 'success' : 'danger'}"
        html += <<-HTML
        <div class="#{msgclass}">
          <button type="button" class="close" data-dismiss="alert">&times;</button>
          <div id="flash_#{name}">#{msg}</div>
        </div>
        HTML
      end
    end
    html.html_safe
  end

  def form_error_messages!(object)
    return "" if object.errors.empty?

    messages = object.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
    sentence = I18n.t("errors.template.header",
                      count: object.errors.count,
                      model: object.class.model_name.human.downcase)
    bodyhead = I18n.t("errors.template.body")

    html = <<-HTML
    <div id="error_explanation">
      <h2>#{sentence}</h2>
      <p>#{bodyhead}</p>
      <ul>#{messages}</ul>
    </div>
    HTML

    html.html_safe
  end

  def localize_date(dt)
    dt.strftime(I18n.t(:"datetime.formats.date"))
  end

  def localize_time(dt)
    dt.strftime(I18n.t(:"datetime.formats.time"))
  end

  def show_price(price)
    number_with_precision(price, precision: 2)
  end
end
