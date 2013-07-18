# Automatic Online Dba

from bottle import route, run

@route('/api/<vers:float>/<cstid>/<compid>/')
def api_call(vers):
	return 'vers: ', str(vers)

run(host='localhost', port=8080, debug=True)