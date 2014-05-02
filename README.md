redis-instance
==============

A script to set up multiple Redis instance on the same machine.

**Notes:**
- You need to run the script as root.
- This script is tested only on Debian
- This script copy a orginal config of Redis instance

**Usage:**
./redis-instance [instance name] [instance port]


**Example:**
./redis-instance session 5412

Will create an new instance called redis-session listening on the port 5412

**Author:
Mohammed Abdallah <palcoder1@gmail.com>
