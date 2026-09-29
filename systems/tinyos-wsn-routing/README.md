# TinyOS WSN Routing Tree

Project for **PLH511 — Wireless Sensor Networks** (TUC, 2023). A TinyOS application in
nesC that builds a **routing tree** over a network of sensor motes and sends data up the tree
to the root (sink). It runs in the **TOSSIM** simulator on generated grid topologies.

## How it works

1. **Routing phase**: the root floods a `RoutingMsg`. Each node picks the first sender it
   hears as its parent and forwards the message, so a tree forms rooted at the sink.
2. **Notify phase**: nodes send `NotifyParentMsg` to their parent, so parents learn about
   their children.
3. Outgoing and incoming messages are buffered in queues (`PacketQueueC`) and handled by
   TinyOS tasks.

## Files

| File | Purpose |
|------|---------|
| `SRTreeC.nc`, `SRTreeAppC.nc` | Main module and its wiring (timers, radio, serial) |
| `SimpleRoutingTree.h` | Message formats and constants |
| `PacketQueue.nc`, `PacketQueueC.nc` | Packet queue interface and implementation |
| `topo_generator.py` | Builds a `D × D` grid topology where nodes within a given radio range are linked |
| `mySimulation.py` | TOSSIM script: loads a topology, boots the nodes and runs the simulation |
| `topology*.txt` | Generated topologies |
| `README` | Original course README (flags, mote install commands) |

## Run the simulation

Needs a TinyOS 2.x toolchain with TOSSIM (Python 2).

```sh
python3 topo_generator.py 8 1.5 topology.txt   # diameter, range, output file
make micaz sim                                 # build for TOSSIM
python2 mySimulation.py topology.txt           # run
```

## More work

Later work (part 1 of the aggregation phase, more topologies) is on the
`archive/tinyos-wsn-routing/python2_version` tag of this repository.
