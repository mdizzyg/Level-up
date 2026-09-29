from fastapi import FastAPI

app = FastAPI(
    title="LEVEL UP API",
    version="0.1.0"
)


@app.get("/")
def root():
    return {"message": "LEVEL UP API is running"}