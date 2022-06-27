from flask import Flask, render_template
from web3 import Web3
import config

app = Flask(__name__)

w3 = Web3(Web3.HTTPProvider(config.ALCHEMY_URL))


@app.route("/")
def hello_world():
    return "<p>Hello, World!</p>"


@app.route("/address/<addr>")
def address(addr):
    return render_template("address.html", addr=addr)


@app.route("/tx/<hash>")
def transaction(txHash):
    tx = w3.eth.get_transaction(txHash)
    return render_template("transaction.html", hash=txHash, tx=tx)


@app.route("/block/<number>")
def block(number):
    return render_template("block.html", number=number)
