# frozen_string_literal: true

require 'digest'
require 'sinatra'
require 'sinatra/support/i18nsupport'
require 'passbook'
require 'active_support/json/encoding'
require 'dotenv/load'
require 'json'
require_relative 'lib/passbook_monkeypatch'
require_relative 'helpers/locale_helper'
require_relative 'helpers/pass_helper'

helpers LocaleHelper
helpers PassHelper

register Sinatra::I18nSupport
load_locales './config/locales'

enable :sessions

before do
  assign_locale(params[:locale].to_sym) if params[:locale]
end

Passbook.configure do |passbook|
  passbook.p12_password = ENV['p12_password']
  passbook.p12_key = ENV['pass_key'] # 'passkey.pem'
  passbook.p12_certificate = ENV['pass_certificate'] # 'passcertificate.pem'
  passbook.wwdc_cert = ENV['wwdr'] # 'WWDR.pem'
end

PASS_TEMPLATE = ERB.new(File.read('views/pass.json.erb'))

get '/' do
  erb :home
end

get '/scan' do
  erb :scanner, layout: false
end

post '/api/pass' do
  qr_json = JSON.parse(params[:qr_content])
  serial_number = serial_number(qr_json)
  entries = qr_json.dig('payload', 'vc', 'credentialSubject', 'fhirBundle', 'entry')
  # TODO: access hash with keys instead of array positions for redundancy,
  name = name(entries[0])
  # shot_status = shot_status(entries[2])
  location = location(entries[2])

  pass = PASS_TEMPLATE.result_with_hash(
    name: name,
    qr_content: params[:raw_shc],
    location: location,
    # TODO: payload is already sent in the clear from the post request
    serial_number: Digest::SHA256.hexdigest(serial_number)
  )

  passbook = Passbook::PKPass.new(pass)
  passbook.addFiles(['icons/icon.png', 'icons/icon@2x.png'])
  response['Content-Type'] = 'application/vnd.apple.pkpass'
  attachment 'mypass.pkpass'
  passbook.stream.string
end

not_found do
  status 404
  erb :not_found
end
