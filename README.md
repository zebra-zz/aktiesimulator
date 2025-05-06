# Aktiesimulator

Det här är ett enkelt Python/Flask-baserat program som simulerar aktiepriser och visar dem på en webbsida. Varje aktie uppdateras med exponentialfördelade tidsintervall och simulerad avkastning enligt en stokastisk modell (Geometrisk Brownsk rörelse).

## 🏁 Kom igång

### 1. Klona repot
```bash
git clone git@github.com:zebra-zz/aktiesimulator.git
cd aktiesimulator

python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
python run.py
http://localhost:5000

deactivate
