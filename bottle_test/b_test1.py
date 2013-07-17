from bottle import route, run

@route('/hello')
def hello():
	return "Hello Morten"

run(host='localhost', port=8080, debug=True)