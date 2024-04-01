import os
from fastapi import FastAPI,HTTPException
from fastapi.middleware.cors import CORSMiddleware
from Base64Test.base64_text import Base64Text
from chatter.claude_opus_chatter import ClaudeOpusChatter
from chatter.openai_chatter import OpenAIChatter
from model.get_topic import GetTopicRequestItem

origins = [
    "http://localhost",
    "http://127.0.0.1:41639",
    "http://127.0.0.1:36611",
    "https://yanelmo.net",
]

# uvicorn main:app --reload --port 8000
app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

system_role = """あなたは話題を考えてくれるアシスタントです。
与えられた状況から、以下の内容を考えてください。
- 親しい人に対しての話題
- 目上の人に対しての話題

回答には、以下のフォーマットを必ず含めてください。
また、それぞれの提案についてどのように話題を展開していくかのサンプルを提示してください。

フォーマット：
# 親しい人に対して
- あなたの考えた話題_1
- あなたの考えた話題_2
- あなたの考えた話題_3

# 目上の人に対して
- あなたの考えた話題_1
- あなたの考えた話題_2
- あなたの考えた話題_3
"""

# chatter = ClaudeOpusChatter(
#         api_key=os.getenv("ANTHROPIC_API_KEY"),
#         model=os.getenv("ANTHROPIC_MODEL"),
#         system_role=system_role)

chatter = OpenAIChatter(
    api_key=os.getenv("OPENAI_API_KEY"),
    model=os.getenv("OPENAI_MODEL"),
    system_role=system_role
)

@app.get("/")
async def root():
    return {"message": "Hello World"}

@app.post("/getTopic/")
async def get_topic(item:GetTopicRequestItem):
    # validate the input
    if item.prompt == "":
        raise HTTPException(status_code=400, detail="prompt is required")
    
    if item.dry_run:
        return {
            "model": chatter.model,
            "response": f"dry run is enabled. Your request is valid.\n(prompt:{item.prompt})"
        }
    else:
        try:
            response = await chatter.chat(memory_id=item.apikey,message=item.prompt,base64_str=item.picture_base64)
        except Exception as e:
            raise HTTPException(status_code=500, detail=str(e))

        return {
            "model": chatter.model,
            "response": response
        }
    