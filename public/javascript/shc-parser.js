// Extracted from obrassard/shc-extractor on August 29th, 2021 Under MIT License
// https://github.com/obrassard/shc-extractor/blob/main/src/parsers.js
//

const zlib = require('zlib');

function parseShc(rawSHC) {
	const jwt = numericShcToJwt(rawSHC);
	const splitJwt = jwt.split(".")
	const header = parseJwtHeader(splitJwt[0])
	const payload = parseJwtPayload(splitJwt[1])

	return {
		header,
		payload,
	}
}

function numericShcToJwt(rawSHC) {
	if (rawSHC.startsWith('shc:/')) {
		rawSHC = rawSHC.split('/')[1];
	}
	return rawSHC
		.match(/(..?)/g)
		.map((number) => String.fromCharCode(parseInt(number, 10) + 45))
		.join("")
}

function parseJwtHeader(header) {
	const headerData = Buffer.from(header, "base64");
	return JSON.parse(headerData)
}

function parseJwtPayload(payload) {
	const payloadBuffer = Buffer.from(payload, "base64");
	const payloadJson = zlib.inflateRawSync(payloadBuffer)
	return JSON.parse(payloadJson);
}

// export to the global scope for use in the browser
window.parseShc = parseShc;