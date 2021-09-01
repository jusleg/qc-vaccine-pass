# frozen_string_literal: true

require "spec_helper"
require './helpers/shc_helper'

RSpec.describe ShcHelper do
  include ShcHelper

  let(:serial_num) { '3Kfdg-XwP-7gXyywtUfUADwBumDOPKMQx-iELL11W9s' }
  let(:hospital_on) { 'ABC General Hospital' }
  let(:hospital_qc) { '06 HOPITAL GENERAL DE MONTREAL' }
  let(:given_name) { ['John', 'D.'] }
  let(:family_name) { ['Cena'] }
  let(:bday) { '1951-01-20' }
  let(:first_shot_date) { '2021-01-29' }
  let(:second_shot_date) { '2021-03-29' }
  let(:status)  { 'Completed' }
  let(:entries) {
    [
      {
        'fullUrl' => 'resource:0',
        'resource' => {
          'resourceType' => 'Patient',
          'name' => [{ 'family' => family_name, 'given' => given_name }],
          'birthDate' => bday,
        }
      },
      {
        'fullUrl' => 'resource:1',
        'resource' => {
          'resourceType' => 'Immunization',
          'status' => status,
          'vaccineCode' => {
            'coding' => [{ 'system' => 'http://hl7.org/fhir/sid/cvx', 'code' => '207' }]
          },
          'patient' => { 'reference' => 'resource:0' },
          'occurrenceDateTime' => first_shot_date,
          'performer' => [{ 'actor' => { 'display' => hospital_on } }],
          'lotNumber' => 'FD7206'
          'note' => [{
            'text' => 'PB COVID-19',
          }],
        }
      },
      {
        'fullUrl' => 'resource:2',
        'resource' => {
          'resourceType' => 'Immunization',
          'status' => status,
          'vaccineCode' => {
            'coding' => [{ 'system' => 'http://hl7.org/fhir/sid/cvx', 'code' => '207' }]
          },
          'patient' => { 'reference' => 'resource:0' },
          'occurrenceDateTime' => second_shot_date,
          "location" => {
            "reference" => "resource:0",
            "display" => hospital_qc
          },
          'lotNumber' => 'FD7206',
          'note' => [{
            'text' => 'PB COVID-19',
          }],
        }
      }
    ]
  }

  let(:shc_payload) do
    {
      'header' => {
        'zip' => 'DEF',
        'alg' => 'ES256',
        'kid' => serial_num,
      },
      'payload' => {
        'iss' => 'https://smarthealth.cards/examples/issuer',
        'nbf' => 1_620_847_989.837,
        'vc' => {
          'type' => [
            'https://smarthealth.cards#health-card',
            'https://smarthealth.cards#immunization',
            'https://smarthealth.cards#covid19'
          ],
          'credentialSubject' => {
            'fhirVersion' => '4.0.1',
            'fhirBundle' => {
              'resourceType' => 'Bundle',
              'type' => 'collection',
              'entry' => entries,
            }
          }
        }
      }
    }
  end

  it 'retrieves the locations' do
    expect(location(entries[1])).to eq(hospital_on.tr("0-9", ""))
    expect(location(entries[2])).to eq(hospital_qc.tr("0-9", ""))
  end

  it 'retrieves the vaccination date' do
    expect(date(entries[1])).to eq(first_shot_date)
    expect(date(entries[2])).to eq(second_shot_date)
  end

  it 'retrieves the vaccination status' do
    expect(shot_status(entries[1])).to eq(status)
    expect(shot_status(entries[2])).to eq(status)
  end

  it 'retrieves the patients name' do
    expect(name(entries[0])).to eq('John D. Cena')
  end

  it 'retrieves the patients birth date' do
    expect(birth_date(entries[0])).to eq(bday)
  end

  it 'retrieves the serial number' do
    expect(serial_number(shc_payload)).to eq(serial_num)
  end
end
