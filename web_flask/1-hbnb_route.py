#!/usr/bin/python3
"""Script to start a Flask web application with two routes."""

from flask import Flask


app = Flask(__name__)


@app.route('/', strict_slashes=False)
def hello_world():
    """ Returns some text. """
    return 'Hello HBNB!'


@app.route('/hbnb', strict_slashes=False)
def hello():
    """ Return other text. """
    return 'HBNB'

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)