import http.client

conn = http.client.HTTPSConnection("api.asgardeo.io")
payload = 'grant_type=client_credentials&scope=internal_user_mgt_view'
headers = {
  'Content-Type': 'application/x-www-form-urlencoded',
  'Authorization': 'Basic b2dBYzFoT183UFBJSE02eEZsbFVVdjhpQnBZYToyVDJvZlhnSTVacF9sSzhya2kyVkRjMWpNbmR1a0pOOGJXZXpUS3U3ZWxVYQ==',
}
conn.request("POST", "/t/interns/oauth2/token", payload, headers)
res = conn.getresponse()
data = res.read()
print(data.decode("utf-8"))