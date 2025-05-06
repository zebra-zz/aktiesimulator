# app/routes.py
from flask import Blueprint, render_template, jsonify
#from app.models import get_instrument_prices

bp = Blueprint('main', __name__)

@bp.route('/')
def index():
    return render_template('index.html')

#@bp.route('/api/prices')
#def prices():
#    prices = get_instrument_prices()
#    return jsonify(prices)

