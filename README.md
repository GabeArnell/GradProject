# Thrift Exchange Project

## Installation

Clone the project to your local computer and run the `npm install` to get the node packages.
There are two files missing from the repo that you need to add yourself or ask for a copy of (as it contains the security keys to the databases and encryption)
`/server/config.json`
This is a JSON file that contains the port number, token encryption key, and the database credentials 

`/lib/constants/server_path.dart`
Contains the SERVER_URI string global variable that has the IP of the backend server. (Set this to your local computer's IP address).
