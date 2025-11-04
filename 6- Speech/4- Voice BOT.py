from openai import AzureOpenAI
from dotenv import load_dotenv
from openai import AzureOpenAI
import os


load_dotenv()
GPT_REALTIME_ENDPOINT=os.getenv("GPT_REALTIME_ENDPOINT")
GPT_REALTIME_KEY=os.getenv("GPT_REALTIME_KEY")

client = AzureOpenAI(
    azure_endpoint=GPT_REALTIME_ENDPOINT,
    api_key=GPT_REALTIME_KEY,
    api_version="2024-10-01-preview"  # or the latest available
)

# Define your role prompts
AI_ASSISTANT_PROMPT = """You are a helpful customer service assistant for our company.

Your role is LIMITED to the following topics only:
1. Product information and availability
2. Store hours and location
3. Return and exchange policies
4. Order status inquiries
5. Basic technical support

IMPORTANT INSTRUCTIONS:
- If a caller requests to speak with a "live agent" or "human agent", immediately acknowledge their request and inform them you're transferring them to the queue.
- If the caller asks about topics outside your allowed scope, politely explain you can transfer them to a specialist.
- Keep responses concise and professional.
- Always be helpful and courteous.

When you detect a request for a live agent, respond with:
"I understand you'd like to speak with a live agent. Let me transfer you to our team right away."
"""

WORKING_HOURS_PROMPT = """You are a helpful customer service assistant for our company.

Our office is currently CLOSED. Our working hours are 09:00 to 22:00.

Your role is LIMITED to the following topics only:
1. Providing information about working hours
2. Taking messages for callbacks
3. Answering basic frequently asked questions
4. Product information (general)

IMPORTANT INSTRUCTIONS:
- If a caller requests to speak with a "live agent" or "human agent", politely inform them about our working hours:
"I understand you'd like to speak with a live agent. Our office hours are 09:00 to 22:00. Would you like me to take a message for a callback during business hours?"
- Keep responses concise and professional.
- Always be helpful and courteous.
"""

# Choose which prompt to use
current_prompt = AI_ASSISTANT_PROMPT  # or WORKING_HOURS_PROMPT

# Create a completion request
response = client.chat.completions.create(
    model="gpt-4o-realtime-preview",  # ensure this model is deployed in your Azure resource
    messages=[
        {"role": "system", "content": current_prompt},
        {"role": "user", "content": "Hi, can I return an item I bought last week?"}
    ],
    max_tokens=200,
    temperature=0.7
)

# Print the assistant's reply
print(response.choices[0].message["content"])
