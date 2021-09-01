# frozen_string_literal: true

module ShcHelper
  # QC and ON have different location objects
  def location(entry)
    result = entry.dig('resource', 'performer', 0, 'actor', 'display') ||
             entry.dig('resource', 'location', 'display')
    result&.tr("0-9", "")
  end

  def date(entry)
    entry.dig('resource', 'occurrenceDateTime')
  end

  def shot_status(entry)
    entry.dig('resource', 'status')
  end

  def name(entry)
    person = entry.dig('resource', 'name', 0)
    "#{person['given'].join(' ')} #{person['family']}"
  end

  def serial_number(payload)
    payload.dig('header', 'kid')
  end
end
