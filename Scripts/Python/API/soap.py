import requests

url = "https://example.com/endpoint"

headers = {"content-type" : "application/soap+xml"}
data = """
<insert soap xml here>
"""

req_post = requests.post(url, data, headers, auth=('user','pass'))

print(req_post.text)