# QC Vaccine Pass

Service issuing iOS passes for Quebec COVID-19 Vaccine Passport. You need a valid vaccine proof to be able to generate a Passkit version that can be used in the wallet app.


<img width="1440" alt="image" src="https://user-images.githubusercontent.com/4406751/131231193-7f14fafb-4e2c-489c-95a9-091ead7e5a5b.png">

## Development

```console
cd backend
bundle install
ruby app.rb
```

A `.env` file with the proper certicates is required to sign iOS passes.

## Repo structure

Both the mobile client and backend are fairly small; therefore, they will both be in the same repo. Below is the folder structure:

* `backend`: Sinatra (ruby) app issuing passes
* `client`: React native app that talks to the backend
