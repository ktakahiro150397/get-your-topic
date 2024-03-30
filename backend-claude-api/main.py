from fastapi import FastAPI

# uvicorn main:app --reload --port 8000

app = FastAPI()

@app.get("/")
async def root():
    return {"message": "Hello World"}