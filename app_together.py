import os
from tools import obter_chave_together
from together import Together
from babel.dates import format_datetime, Locale

locale = Locale('pt_BR')

client_together = Together(api_key= obter_chave_together())

response = client_together.chat.completions.create(
    model="meta-llama/Llama-3-70b-chat-hf",
    messages=[{"role": "user", "content": "Me fale sobre as luas de saturno?"}],
)

print(response.choices[0].message.content)
