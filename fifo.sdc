

create_clock -name clk -period 4.0 [get_ports clk]



set_clock_uncertainty -setup 0.15 [get_clocks clk]
set_clock_uncertainty -hold  0.1 [get_clocks clk]


set_input_delay  -max 0.5 -clock clk [all_inputs]
set_input_delay  -min 0.1 -clock clk [all_inputs]
set_output_delay -max 0.5 -clock clk [all_outputs]
set_output_delay -min 0.1 -clock clk [all_outputs]


set_max_transition 0.15 [current_design]
set_max_capacitance 0.1  [current_design]
set_max_fanout 16 [current_design]


set_max_area 0
