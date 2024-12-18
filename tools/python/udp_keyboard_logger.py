import socket
from pynput import keyboard

ip = "127.0.0.1"
port = 9996

client_socket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
client_socket.settimeout(None)
client_socket.connect((ip, port))

def on_press(key):
    client_socket.send(f'pressed:{key}'.encode())
    try:
        print(f'alphanumeric key {key.char} {key.vk} pressed')
    except AttributeError:
        print(f'special key {key} pressed')

def on_release(key):
    client_socket.send(f'released:{key}'.encode())
    print(f'{key} released')
    if key == keyboard.Key.esc:
        # Stop listener
        return False

listener = keyboard.Listener(
    on_press=on_press,
    on_release=on_release,
    suppress=False
    )
listener.start()

while True:
    data, (recv_ip, recv_port) = client_socket.recvfrom(1024)
    print(f"Received: '{data.decode()}' {recv_ip}:{recv_port}")