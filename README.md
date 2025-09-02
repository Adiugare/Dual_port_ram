# Dual_port_ram

This project implements a 16x8 synchronous dual-port RAM in Verilog.

Memory size: 16 locations (4-bit address space), each 8 bits wide.
Dual-port feature: Two independent ports (Port A and Port B) can simultaneously perform read and write operations on different memory locations.
Synchronous design: Both ports are clocked, and all read/write operations occur on the positive edge of the clock.
This type of memory is widely used in FPGAs, processors, and DSP architectures where multiple access points are required.

 Module Description
🔹 Module: dual_port_ram

Inputs:

clk: System clock (common for both ports)
we_a: Write enable for Port A
addr_a [3:0]: Address input for Port A
din_a [7:0]: Data input for Port A
we_b: Write enable for Port B
addr_b [3:0]: Address input for Port B
din_b [7:0]: Data input for Port B

Outputs:

dout_a [7:0]: Data output from Port A
dout_b [7:0]: Data output from Port B

Internal memory:
reg [7:0] mem [0:15];
→ Declares a memory block with 16 locations (each 8-bit wide).

🔹 Functionality

On every positive clock edge:

If we_a = 1, data at din_a is written to mem[addr_a].
If we_b = 1, data at din_b is written to mem[addr_b].
Outputs dout_a and dout_b always reflect the contents of the addressed memory location.

⚠️ Note: If both ports access the same address simultaneously, behavior is undefined (depends on synthesis tool / FPGA memory).

Testbench Description
🔹 Module: dual_port_ram_tb

The testbench verifies correct dual-port RAM operation with various scenarios:

Clock generation:

initial begin
    clk = 0;
    forever #5 clk = ~clk; // 10 ns clock period
end


Tasks:

initialize() → Resets signals.

write_a(addr, data) → Writes data to Port A.

write_b(addr, data) → Writes data to Port B.

read_a(addr) → Reads from Port A.

read_b(addr) → Reads from Port B.

delay() → Inserts simulation delay.

Stimulus sequence:

Initialize all signals.

Write data 1011 to address 8 via Port A, then read it.

Write data 0101 to address A via Port B, then read it.

Perform simultaneous writes on both ports (Port A → 1011 at addr B, Port B → 0010 at addr 1).

Read back both locations from Port A and Port B.

End simulation.

Monitor statement prints real-time status of both ports:

Time=XX | A: we=... addr=... din=... dout=... || B: we=... addr=... din=... dout=...

✅ Expected Behavior

Data written on Port A should be immediately available when reading back from the same address.
Data written on Port B should be correctly retrieved when read.
Both ports can work independently (parallel read/write).
If both ports write to the same location simultaneously, the final stored value depends on simulation/synthesis (not deterministic).

🔮 Possible Extensions

Add asynchronous read support.
Add write-first / read-first policy selection.
Handle simultaneous access conflicts with priority logic.
Expand memory depth and width.
