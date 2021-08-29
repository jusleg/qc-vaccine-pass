# frozen_string_literal: true

require 'digest'
require 'sinatra'
require 'sinatra/support/i18nsupport'
require 'passbook'
require 'active_support/json/encoding'
require 'dotenv/load'
require_relative 'lib/passbook_monkeypatch'
require_relative 'helpers/locale_helper'

helpers LocaleHelper

register Sinatra::I18nSupport
load_locales './config/locales'

enable :sessions

before do
  set_locale(params[:locale].to_sym) if params[:locale]
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

get '/manual' do
  erb :form
end

post '/api/pass' do
  pass = PASS_TEMPLATE.result_with_hash(
    name: params[:name],
    qr_content: params[:qr_content],
    location: params[:location],
    serial_number: Digest::SHA256.hexdigest(params[:qr_content])
  )
  passbook = Passbook::PKPass.new(pass)
  passbook.addFiles(['icons/icon.png', 'icons/icon@2x.png'])
  response['Content-Type'] = 'application/vnd.apple.pkpass'
  attachment 'mypass.pkpass'
  passbook.stream.string
end

get '/demo' do
  pass = PASS_TEMPLATE.result_with_hash(
    name: "it works",
    qr_content: "Wassup",
    location: "Montreal",
    serial_number: 1234
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
