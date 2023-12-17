module debouncer(
    input clk,
    input resetn,
    input noisy_signal,
    output reg debounced_signal
);

    parameter DEBOUNCE_INTERVAL = 1000000; 
    reg [19:0] counter;  
    reg last_stable_signal;  // To store the last stable state of the signal

    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            counter <= 0;
            debounced_signal <= 0;
            last_stable_signal <= 0;
        end else begin
            if (noisy_signal != last_stable_signal) begin
                // Signal changed, update last stable signal and reset counter
                last_stable_signal <= noisy_signal;
                counter <= 0;
            end else if (counter < DEBOUNCE_INTERVAL) begin
                counter <= counter + 1;
            end else if (counter == DEBOUNCE_INTERVAL) begin
                debounced_signal <= last_stable_signal;
            end
        end
    end
endmodule

