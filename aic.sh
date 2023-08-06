#!/bin/bash

# Get diff from the last commit
DIFF=$(git diff --staged)

# OpenAI API key
API_KEY='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'

#JQ FOR PREP
data=$(jq -n \
    --arg diff "$DIFF" \
    '{
      messages: [ 
      {"role":"system", "content":"I need you to make me a relevent and thorough but concise git commit for the following diff."},
      {"role":"user", "content":$diff}
      ],
      max_tokens: 600,
      model: "gpt-4"
    }'
)

# THE SAUCE
message=$(curl https://api.openai.com/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $API_KEY" \
  -d "$data" )
#  jq -r '.choices[0].message.content' | tr '\n' ' ')

# Display the commit message and ask for confirmation
echo -e "\nThe proposed commit message is:\n$message"
read -p "Do you want to proceed with this commit message? (y/n) " confirm
if [[ $confirm == "y" || $confirm == "Y" ]]; then
  git commit -m "$message"
  echo "Commit created with message: $message"
else
  echo "Commit canceled"
fi
