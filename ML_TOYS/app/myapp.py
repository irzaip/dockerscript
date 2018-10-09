from flask import Flask
app = Flask(__name__)

@app.route("/")
def hello():
        return "Hello there"

@app.route("/test1")
def hello2():
        return "HELLO TEST1"

@app.route('/<string:page_name>/') 
def render_static(page_name):     
    return render_template('%s.html' % page_name)    

if __name__ == "__main__":
        app.run(host='0.0.0.0')

