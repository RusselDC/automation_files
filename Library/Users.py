import requests

class Users:

    #https://jsonplaceholder.typicode.com/users

    def get_users_via_api(self):
        response = requests.get("https://jsonplaceholder.typicode.com/users", verify=False) 
        return response.json()




