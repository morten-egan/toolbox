from bottle import route, run

@route('/hello/<name>')
def hello(name='NA'):
	return template('Hello {{name}}', name=name)

run(host='localhost', port=8080, debug=True)