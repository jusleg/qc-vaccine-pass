# frozen_string_literal: true

module LocaleHelper
  def assign_locale(new_locale)
    allowed_locales = [:en, :fr]

    session[:locale] = if allowed_locales.include?(new_locale)
                         new_locale
                       else
                         default_locale
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
