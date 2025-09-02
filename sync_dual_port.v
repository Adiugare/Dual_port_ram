// 16x8 Synchronous Dual-Port RAM
module dual_port_ram (
    input clk,
    // Port A
    input we_a,
    input [3:0] addr_a,
    input [7:0] din_a,
    output reg [7:0] dout_a,
    // Port B
    input we_b,
    input [3:0] addr_b,
    input [7:0] din_b,
    output reg [7:0] dout_b
);

    // Memory declaration: 16 locations, each 8 bits wide
    reg [7:0] mem [0:15];

    // Port A operation
    always @(posedge clk) begin
        if (we_a)
            mem[addr_a] <= din_a;       // Write
        dout_a <= mem[addr_a];          // Read
    end

    // Port B operation
    always @(posedge clk) begin
        if (we_b)
            mem[addr_b] <= din_b;       // Write
        dout_b <= mem[addr_b];          // Read
    end

endmodule
                                                                                                                                                                                  
