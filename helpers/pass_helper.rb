# frozen_string_literal: true

module PassHelper
  def location(entry)
    entry.dig('resource', 'performer', 0, 'actor', 'display')
  end

  def date(entry)
    entry.dig('resource', 'occurrenceDateTime')
  end

  def shot_status(entry)
    entry.dig('resource', 'status')
  end

  def name(entry)
    person = entry.dig('resource', 'name')
    "#{person[0]['given'][0]} #{person[0]['family'].join(' ')}"
  end

  def serial_number(payload)
    payload.dig('header', 'kid')
  end
end
