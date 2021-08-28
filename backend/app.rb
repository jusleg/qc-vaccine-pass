# frozen_string_literal: true

require 'sinatra'
require 'passbook'
require 'active_support/json/encoding'
require 'dotenv/load'
require_relative 'passbook_monkeypatch'

Passbook.configure do |passbook|
  passbook.p12_password = ENV['p12_password']
  passbook.p12_key = ENV['pass_key'] # 'passkey.pem'
  passbook.p12_certificate = ENV['pass_certificate'] # 'passcertificate.pem'
  passbook.wwdc_cert = ENV['wwdr'] # 'WWDR.pem'
end

PASS_TEMPLATE = File.read('views/pass.json.erb')

get '/passbook' do
  pass = ERB.new(PASS_TEMPLATE).result
  passbook = Passbook::PKPass.new(pass)
  passbook.addFiles(['icons/icon.png', 'icons/icon@2x.png'])
  response['Content-Type'] = 'application/vnd.apple.pkpass'
  attachment 'mypass.pkpass'
  passbook.stream.string
end
