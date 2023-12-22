from flask import Flask
import logging
import psycopg2
import redis
import sys
import os

app = Flask(__name__)
# CHANGE THE CONN FIELD
cache = redis.Redis(host='redis', port=6379)

#r#edis_url = os.environ.get('REDIS_URL', default='redis://redis:6379/0')
#cache = redis.from_url(redis_url)

# Configure Logging
app.logger.addHandler(logging.StreamHandler(sys.stdout))
app.logger.setLevel(logging.DEBUG)

def PgFetch(query, method):

    # Connect to an existing database
    # CHANGE THE CONN FIELD
    conn = psycopg2.connect("host='postgres' dbname='app' user='postgres' password='1234'")
    #conn = psycopg2.connect(os.environ.get('POSTGRES_URL', default='postgresql://postgres:1234@postgres/app'))

    # Open a cursor to perform database operations
    cur = conn.cursor()

    # Query the database and obtain data as Python objects
    dbquery = cur.execute(query)

    if method == 'GET':
        result = cur.fetchone()
    else:
        result = ""

    # Make the changes to the database persistent
    conn.commit()

    # Close communication with the database
    cur.close()
    conn.close()
    return result

@app.route('/')
def hello_world():
    if cache.exists('visitor_count'):
        cache.incr('visitor_count')
        count = (cache.get('visitor_count')).decode('utf-8')
        update = PgFetch("UPDATE visitors set visitor_count = " + count + " where site_id = 1;", "POST")
    else:
        cache_refresh = PgFetch("SELECT visitor_count FROM visitors where site_id = 1;", "GET")
        count = int(cache_refresh[-1])
        cache.set('visitor_count', count)
        cache.incr('visitor_count')
        count = (cache.get('visitor_count')).decode('utf-8')
    return 'Hello Slurm!  This page has been viewed %s time(s).' % count

@app.route('/resetcounter')
def resetcounter():
    cache.delete('visitor_count')
    PgFetch("UPDATE visitors set visitor_count = 0 where site_id = 1;", "POST")
    app.logger.debug("reset visitor count")
    return "Successfully deleted redis and postgres counters"
