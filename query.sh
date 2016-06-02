#!/bin/sh
curl -D - -X GET 'http://0.0.0.0:18080/samples/localhost:chassis:temps?start=1998-07-09T12:05:00-0500&end=1998-07-09T13:15:00-0500'; echo
