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
require_relative 'helpers/shc_helper'

helpers LocaleHelper
helpers ShcHelper

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
  entries = qr_json.dig('payload', 'vc', 'credentialSubject', 'fhirBundle', 'entry')

  pass = PASS_TEMPLATE.result_with_hash(
    name: name(entries[0]),
    birth_date: birth_date(entries[0]),
    status: status_text(shot_status(entries[2])),
    serial_number: Digest::SHA256.hexdigest(serial_number(qr_json)),
    qr_content: params[:raw_shc],
    location_one: location(entries[1]),
    location_two: location(entries[2]),
    date_one: date(entries[1]),
    date_two: date(entries[2]),
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
