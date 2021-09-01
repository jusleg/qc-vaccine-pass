# frozen_string_literal: true

module ShcHelper
  COMPLETED = "✅ Adequately protected"
  PENDING = "🕙 pending"

  # QC and ON have different location objects
  def location(entry)
    return '' if entry.nil? || entry&.empty?

    result = entry.dig('resource', 'performer', 0, 'actor', 'display') ||
             entry.dig('resource', 'location', 'display')
    result&.tr("0-9", "")
  end

  def date(entry)
    return '' if entry.nil? || entry&.empty?

    entry.dig('resource', 'occurrenceDateTime')
  end

  def shot_status(entry)
    return '' if entry.nil? || entry&.empty?

    entry.dig('resource', 'status')
  end

  def status_text(string)
    return PENDING if string.nil? || string&.empty?

    string.downcase.include?('complete') ? COMPLETED : PENDING
  end

  def name(entry)
    return '' if entry.nil? || entry&.empty?

    person = entry.dig('resource', 'name', 0)
    "#{person['given'].join(' ')} #{person['family'].join(' ')}"
  end

  def birth_date(entry)
    return '' if entry.nil? || entry&.empty?

    entry.dig('resource', 'birthDate')
  end

  def serial_number(payload)
    return '' if payload.nil? || payload&.empty?

    payload.dig('header', 'kid')
  end
end
