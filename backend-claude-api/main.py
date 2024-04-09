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
async def get_topic_stream(item:GetTopicRequestItem):
    # validate the input
    if item.prompt == "":
        raise HTTPException(status_code=400, detail="prompt is required")
    
    if item.dry_run:
        testResponse = get_topic_stream_test()

        return StreamingResponse(
            content=testResponse,
        )
    else:
        async def get_stream():
            try:
                print("------------------")

                response = await chatter.chat_stream(memory_id=item.apikey,message=item.prompt,base64_str=item.picture_base64)
                
                async for chunk in response:
                    if chunk is not None:
                        content = chunk.choices[0].delta.content
                        data = {"content":f"{content}"}
                        if content is not None:
                            print(content)
                            yield f"event: RESPONSE\ndata: {json.dumps(data)}\n\n"


            except Exception as e:
                raise HTTPException(status_code=500, detail=str(e))
        
        return StreamingResponse(content=get_stream(),media_type="text/event-stream")

        # return StreamingResponse(
        #     content=get_stream(response),
        #     media_type="text/event-stream",
        # )
    
# async def get_stream(response):
#     async for chunk in response:
#         if chunk is not None:
#             content = chunk.choices[0].delta.content
#             if content is not None:
#                 yield content


    
async def get_topic_stream_test():
    testString = "Dry run is enabled.This is test stream.Your request is valid."
    for i,char in enumerate(testString):
        if i == len(testString) - 1:
            yield {
                "id":"get_topic_stream_test",
                "object":"chat.completion.chunk",
                "created":1712629508,
                "model":"get_topic_stream_test_dry_run",
                "system_fingerprint":None,
                "choices":[
                    {"index":0,"delta":{"content":char},
                    "logprobs":None,"finish_reason":"stop"}]}
        else:
            yield {
                "id":"get_topic_stream_test",
                "object":"chat.completion.chunk",
                "created":1712629508,
                "model":"get_topic_stream_test_dry_run",
                "system_fingerprint":None,
                "choices":[
                    {"index":0,"delta":{"content":char},
                    "logprobs":None,"finish_reason":None}]}
            await asyncio.sleep(50/1000)