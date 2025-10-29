# serve_pickle_server.py
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import pickle, traceback
import uvicorn

MODEL_PATH = "sentiment_model.pkl"
app = FastAPI()
_model = None

class Req(BaseModel):
    prompt: str

def load_model():
    global _model
    if _model is None:
        try:
            # AVISO: pickle.load() pode executar código arbitrário
            with open(MODEL_PATH, "rb") as f:
                _model = pickle.load(f)
        except Exception as e:
            raise RuntimeError("Erro ao carregar modelo: " + str(e))
    return _model

@app.post("/v1/generate")
async def generate(req: Req):
    try:
        model = load_model()
    except Exception:
        raise HTTPException(status_code=500, detail="Erro ao carregar modelo.")
    try:
        if callable(model):
            out = model(req.prompt)
            text = str(out)
        elif hasattr(model, "generate"):
            text = str(model.generate(req.prompt))
        else:
            text = repr(model)[:2000]
        return {"choices":[{"text": text}]}
    except Exception:
        traceback.print_exc()
        raise HTTPException(status_code=500, detail="Erro na geração do modelo.")

if __name__ == "__main__":
    # Executa o servidor quando o script for chamado diretamente
    uvicorn.run("serve_pickle_server:app", host="0.0.0.0", port=8000, reload=False)
