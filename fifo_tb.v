`timescale 1ns/1ps

module fifo_tb;

    // Parameters
    parameter DATA_WIDTH = 8;
    parameter ADDR_WIDTH = 4;
    parameter CLK_PERIOD = 10;

    // Signals
    reg                   clk;
    reg                   rst_n;
    reg                   wr_en;
    reg                   rd_en;
    reg [DATA_WIDTH-1:0]  data_in;
    wire [DATA_WIDTH-1:0] data_out;
    wire                  full;
    wire                  empty;

    // Instantiate UUT (Unit Under Test)
    fifo #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) uut (
        .clk(clk),
        .rst_n(rst_n),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .data_in(data_in),
        .data_out(data_out),
        .full(full),
        .empty(empty)
    );

    // Clock Generation
    always #(CLK_PERIOD/2) clk = ~clk;

    // Main Test Procedure
    initial begin
        // Initialize signals
        clk = 0;
        rst_n = 0;
        wr_en = 0;
        rd_en = 0;
        data_in = 0;

        // Reset Sequence
        repeat(2) @(posedge clk);
        rst_n = 1;
        $display("--- Reset Released ---");

        // --- Test Case 1: Write until Full ---
        $display("Testing: Write until Full");
        repeat(1 << ADDR_WIDTH) begin
            @(posedge clk);
            if (!full) begin
                wr_en = 1;
                data_in = $random % 256;
                $display("[WRITE] Data: %h", data_in);
            end
        end
        @(posedge clk);
        wr_en = 0;
        
        if (full) $display("--- FIFO is Full ---");

        // --- Test Case 2: Read until Empty ---
        $display("Testing: Read until Empty");
        repeat(1 << ADDR_WIDTH) begin
            @(posedge clk);
            if (!empty) begin
                rd_en = 1;
            end
        end
        @(posedge clk);
        rd_en = 0;

        if (empty) $display("--- FIFO is Empty ---");

        // --- Test Case 3: Simultaneous Read/Write ---
        $display("Testing: Simultaneous Read and Write");
        @(posedge clk);
        wr_en = 1;
        rd_en = 1;
        data_in = 8'hAA;
        
        repeat(5) @(posedge clk);
        wr_en = 0;
        rd_en = 0;

        // Finish Simulation
        #50;
        $display("Simulation Completed.");
        $finish;
    end

    // Monitor Outputs
    initial begin
        $monitor("Time: %0t | wr: %b | rd: %b | Full: %b | Empty: %b | Data_Out: %h", 
                 $time, wr_en, rd_en, full, empty, data_out);
    end

    // VCS Waveform Dump (Optional)
    initial begin
        $fsdbDumpfile("dump.fsdb");
        $fsdbDumpvars(0, fifo_tb);
    end

endmodule
