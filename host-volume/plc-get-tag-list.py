#!/usr/bin/env python3
import sys
from pylogix import PLC

# Check that args were passed and if not output with SYNTAX
if len(sys.argv) < 3:
    print('SYNTAX: python plc-get-tag-list.py <ip> <slot-no>')
    sys.exit(1)

ip = sys.argv[1]
slot = int(sys.argv[2])

with PLC() as plc:
	plc.IPAddress = ip
	if slot > 0:
		plc.ProcessorSlot = slot
	tags = plc.GetTagList()
	for t in tags.Value:
		print(t.TagName, t.DataType)