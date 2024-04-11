import asyncio
import json
import os
from urllib.request import Request
from fastapi import FastAPI,HTTPException,status
from fastapi.exceptions import RequestValidationError
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse, StreamingResponse
from Base64Test.base64_text import Base64Text
from chatter.claude_opus_chatter import ClaudeOpusChatter
from chatter.openai_chatter import OpenAIChatter
from model.get_topic import GetTopicRequestItem
from openai.types.chat import ChatCompletion
from sse_starlette.sse import EventSourceResponse

origins = [
    # "http://localhost",
    # "http://127.0.0.1:41639",
    # "http://127.0.0.1:36611",
    # "https://yanelmo.net",
    "*",
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
与えられた状況から、その場で使える話題を考えてください。
最低でも3つ、できれば5つ考えてください。
また、それぞれの話題をどのように展開していくか、会話例を提示してください。

1つの話題につき、以下のフォーマットで答えてください。

1. <あなたが考えた話題1>
[<名前・役職など>]:「XXXXXXXXXX」
[<名前・役職など>]:「XXXXXXXXXX」
[<名前・役職など>]:「XXXXXXXXXX」

2. <あなたが考えた話題2>
(以下同様)
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

@app.exception_handler(RequestValidationError)
async def handler(request:Request, exc:RequestValidationError):
    print(exc)
    return JSONResponse(content={}, status_code=status.HTTP_422_UNPROCESSABLE_ENTITY)

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

@app.post("/getTopicStream/")
async def get_topic_stream(item:GetTopicRequestItem) -> EventSourceResponse:
    # validate the input
    if item.prompt == "":
        raise HTTPException(status_code=400, detail="prompt is required")
    
    if item.dry_run:
        return EventSourceResponse(get_topic_stream_test())
    else:
        def get_stream():
            try:
                print("------------------")
                print("start")

                response = chatter.chat_stream(memory_id=item.apikey,message=item.prompt,base64_str=item.picture_base64)

                for chunk in response:
                    if chunk is not None:
                        content = chunk.choices[0].delta.content
                        data = {"content":f"{content}"}
                        if content is not None:
                            yield content
                print("end")
                print("------------------")

            except Exception as e:
                raise HTTPException(status_code=500, detail=str(e))
        
        return EventSourceResponse(get_stream())

async def get_topic_stream_test():
    testString = "Dry run is enabled.This is test stream.Your request is valid."
    for i,char in enumerate(testString):
        if i == len(testString) - 1:
            yield char
        else:
            yield char
            await asyncio.sleep(50/1000)