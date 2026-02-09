import socket
import time
import random
import math
import sys

HOST = "127.0.0.1"
PORT = 6001
HZ = 20

try:
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    print(f"Socket created: {s}")
except socket.error as e:
    print(f"Error creating socket: {e}")
    sys.exit(1)

try:
    while True:
        value = random.uniform(-math.pi, math.pi)
        message = f"{value:.5f}\n"

        s.sendto(message.encode("utf-8"), (HOST, PORT))
        print(f"sent: {message.strip()}")
        time.sleep(1 / HZ)
except KeyboardInterrupt:
    pass
finally:
    s.close()
    print("Socket closed")
