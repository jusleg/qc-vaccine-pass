# frozen_string_literal: true

module ShcHelper
  COMPLETED = "✅ Adequately protected"
  PENDING = "🕙 pending"

  # QC and ON have different location objects
  def location(entry)
    return '' unless entry.present?

    result = entry.dig('resource', 'performer', 0, 'actor', 'display') ||
             entry.dig('resource', 'location', 'display')
    result&.tr("0-9", "")
  end

  def date(entry)
    return '' unless entry.present?

    entry.dig('resource', 'occurrenceDateTime')
  end

  def shot_status(entry)
    return '' unless entry.present?

    entry.dig('resource', 'status')
  end

  def status_text(string)
    return PENDING unless string.present?

    string.downcase.include?('complete') ? COMPLETED : PENDING,
  end

  def name(entry)
    return '' unless entry.present?

    person = entry.dig('resource', 'name', 0)
    "#{person['given'].join(' ')} #{person['family'].join(' ')}"
  end

  def birth_date(entry)
    return '' unless entry.present?

    entry.dig('resource', 'birthDate')
  end

  def serial_number(payload)
    return '' unless payload.present?

    payload.dig('header', 'kid')
  end
end
