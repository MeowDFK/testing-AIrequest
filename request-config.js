const fs = require("fs");
const { Location, ReturnType, CodeLanguage } = require("@chainlink/functions-toolkit");

const requestConfig = {
    codeLocation: Location.Inline,
    secretsLocation: Location.DONHosted,
    source: fs.readFileSync("./AI-request.js").toString(),
    secrets: { 
        apiKey: process.env.OPENAI_KEY
    },
    args: [], // Arguments will be set dynamically by the contract
    codeLanguage: CodeLanguage.JavaScript,
    expectedReturnType: ReturnType.string,
};

module.exports = requestConfig;
