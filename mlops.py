from flask import Flask, jsonify

app = Flask(__name__)

# Example scores (these would typically be determined by your ML model)
BASELINE_SCORE = 0.75
RETRAINED_SCORE = 0.82

@app.route('/baseline-score', methods=['GET'])
def get_baseline_score():
    # In a real scenario, this would fetch the score from your ML model/metrics
    return jsonify({'baseline_score': BASELINE_SCORE})

@app.route('/retrained-score', methods=['GET'])
def get_retrained_score():
    # Similar to baseline, but this would fetch the score post-retraining
    return jsonify({'retrained_score': RETRAINED_SCORE})

if __name__ == '__main__':
    app.run(debug=True, port=5000)
