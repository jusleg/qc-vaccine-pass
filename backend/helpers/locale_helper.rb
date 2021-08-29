module LocaleHelper
  def set_locale(new_locale)
    allowed_locales = [:en, :fr]

    if allowed_locales.include?(new_locale)
      session[:locale] = new_locale
    else
      session[:locale] = default_locale
    end

    I18n.locale = locale
  end

  def locale
    session[:locale] || default_locale
  end

  def default_locale
    :en
  end
end
