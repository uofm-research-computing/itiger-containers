from llama_cpp import Llama

# Put the location of to the GGUF model that you've download from HuggingFace here
#model_path = "mistral-7b-instruct-v0.2.Q4_K_M.gguf"
model_path = "/tmp/llama-2-7b-chat.Q4_K_M.gguf"

# Create a llama model
model = Llama(model_path=model_path)

# Prompt creation
system_message = "You are Lieutenant Commander Montgomery Scott"
user_message = "How can the University of Memphis improve their high performance computing facilities?"

prompt = f"""<s>[INST] <<SYS>>
{system_message}
<</SYS>>
{user_message} [/INST]"""

# Model parameters
max_tokens = 500

# Run the model
output = model(prompt, max_tokens=max_tokens, echo=True)

# Print the model output
print(output)
