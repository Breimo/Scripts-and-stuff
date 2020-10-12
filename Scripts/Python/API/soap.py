# Libraries
import requests
import datetime

# Global variables
## Date/Time formating
now = datetime.datetime.now()
dt_string = now.strftime("%Y-%m-%d %H:%M:%S")

## List of all customer environments
env_list = ["env1", "env2"]

# Main function
def main():
   env_inputs = env_input()
   api_requests = api_request(env_inputs)
   api_post(env_inputs, api_requests)

# Request user input
def env_input():
   cmd = None
   while cmd != "q":
      user_input = input("Enter environemnt initials: ")
      env_user_input = user_input.lower().strip()
      if env_user_input in env_list:
         break
      elif env_user_input == "q":
         exit("Operation canceled")
      elif env_user_input != "q" and user_input:
         print(f"Sorry, {env_user_input} is not a valid environment.")
   return env_user_input

# Format request based on user input
def api_request(env_user_input):
   user_input = env_user_input
   if user_input == "env1":
      url = "https://env1.com/endpoint"
      headers = {"content-type : application/soap+xml"}
      data = """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">
         <soapenv:Header/>
         <soapenv:Body>
            <login-request>
               <password>password</password>
               <username>username</username>
            </login-request>
         </soapenv:Body>
      </soapenv:Envelope>
      """
      req = requests.post(url, data, headers, auth=('username','password'))
   if user_input == "env2":
      url = "https://env2.com/endpoint"
      headers = {"content-type : application/soap+xml"}
      data = """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">
         <soapenv:Header/>
         <soapenv:Body>
            <login-request>
               <password>password</password>
               <username>username</username>
            </login-request>
         </soapenv:Body>
      </soapenv:Envelope>
      """
      req = requests.post(url, data, headers, auth=('username','password'))
   return req

# Post the request and log to file
def api_post(env_user_input, req):
   env = env_user_input
   request = req
   # Output request to file
   with open(f"{env}-requests.xml", "a") as f:
      print("Request was sent at:", dt_string, file=f)
      print(request.text, "\n", file=f)
   f.close()
   print(f"Response code:", request.status_code)

# Call the main function
main()