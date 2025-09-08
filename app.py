from flask import Flask, request, jsonify

app = Flask(__name__)

@app.get("/hello")
def hello():
    name = request.args.get("name", "").strip()
    who = name if name else "Stranger"
    return jsonify({"message": f"Hello, {who}!"})

@app.get("/add")
def add():
    a = request.args.get("a", "").strip()
    b = request.args.get("b", "").strip()
    if a == "" or b == "":
        return jsonify({"error": "Missing query parameters 'a' and/or 'b'"}), 400
    try:
        # sallitaan kokonais- ja liukuluvut
        a_val = float(a)
        b_val = float(b)
    except ValueError:
        return jsonify({"error": "Parameters 'a' and 'b' must be numbers"}), 400
    return jsonify({"sum": a_val + b_val})

