`timescale 1ns/1ps

module dual_port_ram_tb;

    reg clk;
    reg we_a, we_b;
    reg [3:0] addr_a, addr_b;
    reg [7:0] din_a, din_b;
    wire [7:0] dout_a, dout_b;

    // Instantiate DUT
    dual_port_ram uut (
        .clk(clk),
        .we_a(we_a),
        .addr_a(addr_a),
        .din_a(din_a),
        .dout_a(dout_a),
        .we_b(we_b),
        .addr_b(addr_b),
        .din_b(din_b),
        .dout_b(dout_b)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;   // 10ns period
    end
    
    task initialize();
     begin
        // Initialize
        we_a = 0; we_b = 0;
        addr_a = 0; addr_b = 0;
        din_a = 0; din_b = 0;
     end
    endtask

    // Task to write data on Port A
    task write_a(input [3:0] addr, input [7:0] data);
    begin
        @(negedge clk);
        we_a = 1;
        addr_a = addr;
        din_a  = data;
        @(negedge clk);
        we_a = 0;
    end
    endtask
    
    task delay();
    begin
    #10;
    end
    endtask

    // Task to write data on Port B
    task write_b(input [3:0] addr, input [7:0] data);
    begin
        @(negedge clk);
        we_b = 1;
        addr_b = addr;
        din_b  = data;
        @(negedge clk);
        we_b = 0;
    end
    endtask

    // Task to read data from Port A
    task read_a(input [3:0] addr);
    begin
        @(negedge clk);
        addr_a = addr;
    end
    endtask

    // Task to read data from Port B
    task read_b(input [3:0] addr);
    begin
        @(negedge clk);
        addr_b = addr;
    end
    endtask

    // Stimulus
    initial begin
        initialize;
        // Write & Read operations
        delay;
        write_a(4'b1000, 8'b1011);
        read_a(4'b1000);
        
        delay;
        write_b(4'b1010, 8'b0101);
        read_b(4'b1010);

        // Simultaneous write
        fork
            write_a(4'b1011, 8'b0011);
            write_b(4'b0001, 8'b0010);
        join

        // Read both
        read_a(4'b1011);
        read_b(4'b0001);

        #20 $finish;
    end

    // Monitor
    initial begin
        $monitor("Time=%0t | A: we=%b addr=%h din=%h dout=%h || B: we=%b addr=%h din=%h dout=%h",
                  $time, we_a, addr_a, din_a, dout_a, we_b, addr_b, din_b, dout_b);
    end

endmodule
