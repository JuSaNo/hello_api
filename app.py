from flask import Flask, request, jsonify

app = Flask(__name__)

@app.get("/hello")
def hello():
    name = request.args.get("name", "").strip()
    who = name if name else "Stranger"
    return jsonify({"message": f"Hello, {who}!"})

if __name__ == "__main__":
    # kuuntelee porttia 5000
    app.run(host="0.0.0.0", port=5000)
