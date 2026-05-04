set PDK_PATH ./../ref

 create_lib -technology ./../ref/tech/milkyway/saed32nm_1p9m_mw.tf -ref_lib ./../ref/lib/ndm/saed32rvt_c.ndm fifo.nlib


read_verilog ./../dc/fifo_mapped_netlist.v -library fifo.nlib -design fifo -top fifo


save_lib 
#to open open_lib fifo.nlib
#list_blocks
#then open_block name

save_block -as import_design_done

#sanity checks 

check_netlist
#results 1 or 0 

check_design -checks design_mismatch

report_ref_lib
# u can see name and path location
get_flat_cells



sizeof_collection [get_flat_cells]

get_ports

sizeof_collection [get_ports]

get_pins

sizeof_collection [get_pins]

get_ports -filter "direction==in"

sizeof_collection [get_ports -filter "direction==in"]


get_ports -filter "direction==out"

 sizeof_collection [get_ports -filter "direction==out"]



get_port *clk


initialize_floorplan -core_utilization 0.7 -core_offset 5 


all_inputs


set input_ports [remove_from_collection [all_inputs] [get_ports clk]]

set output_ports [all_outputs]

set clock_port [get_ports clk]


set_block_pin_constraints -side 1 -corner_keepout_distance 8 -pin_spacing 5 -self

 place_pins -port $input_ports

remove_block_pin_constraints
#remove_ports $input_ports

set_block_pin_constraints -side 3 -corner_keepout_distance 13 -pin_spacing 5 -self

 place_pins -port $output_ports


remove_block_pin_constraints  

set_block_pin_constraints -side 2 -self 

place_pins -port $clock_port

remove_block_pin_constraints 

get_lib_cells *DCAP*

get_lib_cells *TIE*

get_lib_cells *FILL*

set_boundary_cell_rules -left_boundary_cell saed32rvt_c/SHFILL1_RVT -right_boundary_cell saed32rvt_c/SHFILL1_RVT -top_boundary_cells saed32rvt_c/SHFILL1_RVT -bottom_boundary_cells saed32rvt_c/SHFILL1_RVT

compile_boundary_cell

 #remove_cells [get_flat_cells *boundary* -all]



save_block -as floorplan_done
save_lib 


get_cells -hier -filter "is_physical_only == true"

====================================









#open the lib and block after saving
#open_lib FULL_ADDER_LIB
#open_block FULL_ADD


# FloorPlan settings
#
#scenario1:
##
initialize_floorplan
set_individual_pin_constraints -ports [get_ports] -sides 3
place_pins -self
create_placement -floorplan
#
save_block -as FULL_ADD
save_lib

#scenario2:
###
#initialize_floorplan -shape R -core_offset 1
#set_individual_pin_constraints -ports [get_ports A] -sides 2
#place_pins -self
#create_placement -floorplan -effort very_low 

#

#scenario3:
#initialize_floorplan -shape L -core_offset 2 -coincident_boundary true
#set_individual_pin_constraints -ports [get_ports {A B}] -sides 6
#place_pins -self
#create_placement -floorplan  -effort medium

#scenario4:
#initialize_floorplan  -core_utilization 0.6 -core_offset {3 3} -coincident_boundary false
#set_individual_pin_constraints -ports [get_ports B] -sides 2 -pin_spacing_distance 3
#place_pins -self
#create_placement -floorplan  -effort high

#scenario5:
#initialize_floorplan -shape L -control_type die  -side_length {20 30 20 20} -core_offset {8}
#set_individual_pin_constraints -ports [get_ports Clock] -exclude_sides {1 2 3 4 5}
#place_pins -self
#create_placement -floorplan  -effort low

#scenario6:
#initialize_floorplan -control_type core -shape T -orientation N -core_offset 50 -side_length {400 200 700 300 700 200}
#set_individual_pin_constraints -ports [get_ports C_in] -location {0 0}
#place_pins -self
#create_placement -floorplan -effort high

#scenario7:
#initialize_floorplan -core_utilization 0.9 -shape T -orientation S -core_offset 2 -flip_first_row true
#set_individual_pin_constraints -offset {1 20} -sides 8 -ports [get_ports]
#place_pins -self
#create_placement -floorplan

#scenario8:
#initialize_floorplan -core_utilization 0.6 -coincident_boundary true -core_offset {1 2} -shape U -orientation E
#set_individual_pin_constraints -ports [get_ports {A[0] B[1]}] -sides "6"
#place_pins -self
#create_placement -floorplan -effort medium

#scenario9:
#initialize_floorplan
#create_placement_blockage -boundary {{3 3} {10 10}}
#place_pins -self
#create_placement -floorplan

#scenario10:
#initialize_floorplan -core_utilization 0.75 -coincident_boundary false -core_offset {1 2} -shape U -orientation W
#create_placement_blockage -type hard -boundary {{4 4} {4 8} {8 8} {8 4}}
#place_pins -self
#create_placement -floorplan




#open_lib <lib name>
##open_block <block name>
#
####################################End of Floorplan Scenarios###############################

