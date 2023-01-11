import requests as http
import json, time

universeId = input("Universe ID to give permissions (ex. 1234567): ")
securityKey = input("ROBLOSECURITY (only include number and letter characters): ")
soundIds = input("List of sound IDs (use ',' as delimiter): ")

def setPermission(id, requestData, sleepTime):
    response = httpSession.patch("https://apis.roblox.com/asset-permissions-api/v1/assets/" + id + "/permissions", data = json.dumps(requestData))
    print("[" + str(response.status_code) + "] " + str(id))

    if response.status_code == 429 or response.status_code == 504:
        if sleepTime == 0:
            sleepTime = 5
        else:
            sleepTime += 5

        print("Roblox limiting requests or server errored, waiting " + str(sleepTime) + " seconds and trying again")
        time.sleep(sleepTime)

        setPermission(id, requestData, sleepTime)
    elif response.status_code != 200:
        try:
            print(response.json())
        except:
            print()



# Attempt to log out the user from Roblox, this will fail, but give a valid x-csrf-token
httpSession = http.Session()
httpSession.cookies[".ROBLOSECURITY"] = securityKey
response = httpSession.post("https://auth.roblox.com/v2/logout")
token = response.headers["x-csrf-token"]
httpSession.close()



# Iterate through sound IDs and put universe ID in permissions
httpSession = http.Session()
httpSession.cookies[".ROBLOSECURITY"] = securityKey
httpSession.headers["x-csrf-token"] = token
httpSession.headers["Content-Type"] = "application/json"

requestData = {
    "requests": [
        {
        "subjectType": "Universe",
        "subjectId": str(universeId),
        "action": "Use"
        }
    ]
}

soundIds.replace(" ", "")
soundIdList = soundIds.split(",")

for id in soundIdList:
    setPermission(id, requestData, 0)


input("Press 'Enter' to exit")