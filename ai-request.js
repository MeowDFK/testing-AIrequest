// AI-request.js

// gets: data from the smart contract
const contractData = args[0]; 

// you can now use contractData in your request and AI prompt
const prompt = `Based on the following data: ${contractData}, please perform the necessary analysis.`;

// requests: OpenAI API using Functions
const openAIRequest = await Functions.makeHttpRequest({
    url: `https://api.openai.com/v1/chat/completions`,
    method: "POST", 
    headers: { 
        "Content-Type": "application/json",
        "Authorization": `Bearer ${secrets.apiKey}`
    },
    data: {
        "model": "gpt-3.5-turbo",
        "messages": [
            {
                "role": "system",
                "content": "You are processing data from a smart contract."
            },
            {
                "role": "user",
                "content": prompt
            }
        ]
    },
    timeout: 10_000,
    maxTokens: 100,
    responseType: "json"
});

const response = await openAIRequest;
const result = response.data?.choices[0].message.content;

console.log(`AI Response: ${result}`);
return Functions.encodeString(result || "Failed");
