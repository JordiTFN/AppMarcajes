import asyncio
import websockets
import json
import pymysql
import datetime
from os import system, name

globalMapTrabajo = {}
globalMapComida = {}


def showMaps():
    system('cls')
    print("-----ESTADO FICHAJES TRABAJO-----")
    for k, v in globalMapTrabajo.items():
        print(k + " -> " + str(v.time()))
    print("\n\n")
    print("-----ESTADO MARCAJES COMIDAS-----")
    for k, v in globalMapComida.items():
        print(k + "->" + str(v.time()))

def getDiff(finTime, inTime):
    diff = finTime - inTime
    amount_in_minutes = diff.total_seconds()/60
    return amount_in_minutes, amount_in_minutes/60

async def getMsg(websocket, path):
    db = pymysql.connect("127.0.0.1", "root", "theforestnext", "marcajes")
    cursor = db.cursor()
    msg = await websocket.recv()
    recvMap = json.loads(msg)
    recvTime = datetime.datetime.strptime(recvMap['time'], '%H:%M')
    if 'TRABAJO' in recvMap['option']:
        cursor.execute(f"INSERT INTO Registros_Trabajo VALUES({int(recvMap['code'])}, STR_TO_DATE('{str(recvMap['date'])}', '%d.%m.%Y'), STR_TO_DATE('{str(recvMap['time'])}', '%T'), '{recvMap['option']}')")
    else:
        cursor.execute(f"INSERT INTO Registros_Comida VALUES({int(recvMap['code'])}, STR_TO_DATE('{str(recvMap['date'])}', '%d.%m.%Y'), STR_TO_DATE('{str(recvMap['time'])}', '%T'), '{recvMap['option']}')")
    if 'ON' in recvMap['option']:
        if 'TRABAJO' in recvMap['option']:
            globalMapTrabajo[recvMap['code']] = recvTime
        elif 'COMIDA' in recvMap['option']:
            globalMapComida[recvMap['code']] = recvTime
    elif 'OFF' in recvMap['option']:
        if 'TRABAJO' in recvMap['option']:
            minutes, hours = getDiff(recvTime, globalMapTrabajo[recvMap['code']])
            cursor.execute(f"INSERT INTO Computos_Trabajo VALUES({recvMap['code']}, STR_TO_DATE('{str(recvMap['date'])}', '%d.%m.%Y'), {minutes}, {hours})")
            globalMapTrabajo.pop(recvMap['code'])
        elif 'COMIDA' in recvMap['option']:
            minutes, hours = getDiff(recvTime, globalMapComida[recvMap['code']])
            cursor.execute(f"INSERT INTO Computos_Comida VALUES({recvMap['code']}, STR_TO_DATE('{str(recvMap['date'])}', '%d.%m.%Y'), {minutes}, {hours})")
            globalMapComida.pop(recvMap['code'])
    db.commit()
    db.close()
    showMaps()

start_server = websockets.serve(getMsg, "192.168.1.11", 9800)
asyncio.get_event_loop().run_until_complete(start_server)
asyncio.get_event_loop().run_forever()