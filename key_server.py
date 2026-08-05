from flask import Flask, request, jsonify
import json
import os

app = Flask(__name__)

def load_keys():
    try:
        with open('keys.json', 'r', encoding='utf-8') as f:
            return json.load(f)
    except:
        return {}

@app.route('/verify')
def verify():
    key = request.args.get('key', '')
    if not key:
        return jsonify({'success': False, 'error': '请输入卡密'})
    keys = load_keys()
    if key in keys:
        return jsonify({'success': True, 'expire_date': keys[key]})
    else:
        return jsonify({'success': False, 'error': '卡密无效'})

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    app.run(host='0.0.0.0', port=port)
