def convert(name):
    caps = name[0].upper() + name[1:]
    lower = name[0].lower() + name[1:]
    out = ''
    out += '[Embed(source="../../assets/levels/'+name+'.txt", mimeType="application/octet-stream")]\n'
    out += 'private static var '+caps+':Class;\n'
    out +=  'public static var '+lower+':ByteArray = new '+caps+'();\n'
    out += 'Embedded.levelObjToString[Embedded.'+lower+'] = "Embedded.'+lower+'";\n\n'
    return out


import sys

names = sys.argv[1:]

for n in names:
    print convert(n)