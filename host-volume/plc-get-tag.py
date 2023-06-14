import sys
from pylogix import PLC

# Check that args were passed and if not output with SYNTAX
if len(sys.argv) < 4:
    print('SYNTAX: python plc-get-tag.py <ip> <slot-no> <tag_name>')
    sys.exit(1)

# IP address and Ethernet/IP port of the PLC
ip = sys.argv[1]
slot = int(sys.argv[2])
port = 44818
# Tag Name to read
tag_name = sys.argv[3]

with PLC() as plc:
  try:
      # Establish a connection to the PLC
      plc.IPAddress = ip
      plc.Port = port
      plc.ProcessorSlot = slot

      # Send a request to read a tag
      response = plc.Read(tag_name)

      # check if the response contains the string Success
      if 'Success' in str(response):
          # get the value of the tag
          value = response.Value
          # print the value of the tag
          print(value)
      else:
          # print the string "error" and then the response
          print('ERROR: ' + str(response))

  except Exception as e:
      print("ERROR:", str(e))
