from fastapi import FastAPI,HTTPException
from model.get_topic import GetTopicRequestItem


# uvicorn main:app --reload --port 8000
app = FastAPI()

@app.get("/")
async def root():
    return {"message": "Hello World"}

@app.post("/getTopic/")
async def get_topic(item:GetTopicRequestItem):
    # validate the input
    if item.prompt == "":
        raise HTTPException(status_code=400, detail="prompt is required")
    
    
    
    return {
        "request":{
            "apikey": item.apikey,
            "prompt": item.prompt,
            "picture_base64": item.picture_base64,
            "dry_run": item.dry_run,
        }
    }
    