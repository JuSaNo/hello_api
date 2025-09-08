from flask import Flask, request, jsonify
import calc

app = Flask(__name__)

@app.get("/hello")
def hello():
    name = request.args.get("name", "").strip()
    who = name if name else "Stranger"
    return jsonify({"message": f"Hello, {who}!"})

def _require_params(*names):
    missing = [n for n in names if not request.args.get(n, "").strip()]
    if missing:
        return f"Missing query parameters {', '.join([repr(m) for m in missing])}"
    return None

@app.get("/add")
def add():
    err = _require_params("a", "b")
    if err:
        return jsonify({"error": err}), 400
    try:
        value = calc.add(request.args["a"], request.args["b"])
        return jsonify({"sum": value})
    except ValueError:
        return jsonify({"error": "Parameters 'a' and 'b' must be numbers"}), 400

@app.get("/subtract")
def subtract():
    err = _require_params("a", "b")
    if err:
        return jsonify({"error": err}), 400
    try:
        value = calc.subtract(request.args["a"], request.args["b"])
        return jsonify({"result": value})
    except ValueError:
        return jsonify({"error": "Parameters 'a' and 'b' must be numbers"}), 400

@app.get("/multiply")
def multiply():
    err = _require_params("a", "b")
    if err:
        return jsonify({"error": err}), 400
    try:
        value = calc.multiply(request.args["a"], request.args["b"])
        return jsonify({"result": value})
    except ValueError:
        return jsonify({"error": "Parameters 'a' and 'b' must be numbers"}), 400

@app.get("/divide")
def divide():
    err = _require_params("a", "b")
    if err:
        return jsonify({"error": err}), 400
    try:
        value = calc.divide(request.args["a"], request.args["b"])
        return jsonify({"result": value})
    except ValueError:
        return jsonify({"error": "Parameters 'a' and 'b' must be numbers"}), 400
    except ZeroDivisionError:
        return jsonify({"error": "Division by zero"}), 400

if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=5000)


