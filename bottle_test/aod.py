# Automatic Online Dba

from bottle import route, run

@route('/favicon.ico')
def empty_call():
	pass

@route('/api/<vers:float>/<cstid>/<compid>')
def api_call(vers, cstid, compid):
	return 'vers: ', str(vers)

run(host='localhost', port=80, debug=True)