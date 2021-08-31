# [QC Vaccine Pass](https://qc-vaccine-pass.herokuapp.com)

Service issuing iOS passes for Quebec COVID-19 Vaccine Passport. You need a valid vaccine proof to be able to generate a Passkit version that can be used in the wallet app.

The application is deployed on a heroku free dyno and you can try it [here](https://qc-vaccine-pass.herokuapp.com).


<img width="1440" alt="image" src="https://user-images.githubusercontent.com/4406751/131231193-7f14fafb-4e2c-489c-95a9-091ead7e5a5b.png">

## Development

```console
bundle
npm install
browserify public/javascript/shc-parser.js -o public/javascript/shc-parser.bundle.js
ruby app.rb
```

To watch html changes and recompile [tailwindcss](https://tailwindcss.com), you can use `bin/tailwind`

We added rubocop to enforce the [relaxed ruby style](https://relaxed.ruby.style).

An `.env` file with the proper certificates is required to sign iOS passes.

# Test
```bash
rspec
```

# Deployment