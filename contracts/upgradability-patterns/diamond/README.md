## Diamond pattern
- Diamond contract.
- interfaces of facet.
- libraries for facet: implement interface && helper function.
    - get storage (format: hash({contract}.storage.{Name}))
- facet contract.

## Diamond Storage pattern 
- Create a Diamond Storage contract (storage contract).
- Create a structure in the storage contract that contains the state variable.
- Choose a position in storage to read and write structure.
- Any contract/proxy/facet that needs to read/write the state variables --> inherit the storage contract.