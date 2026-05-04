

####mode for placement

set mode1 "func"
set corner1 "nom"
set scenario1 "${mode1}::${corner1}"
remove_modes -all; remove_corners -all; remove_scenarios -all

create_mode $mode1
create_corner $corner1
create_scenario -name func::nom -mode func -corner nom
current_mode func
current_scenario func::nom

source ./../DC/fifo_final.sdc 


current_corner nom
current_scenario func::nom

set parasitic1 "p1"
set tluplus_file$parasitic1 "$PDK_PATH/tech/star_rcxt/saed32nm_1p9m_Cmax.tluplus"
set layer_map_file$parasitic1 "$PDK_PATH/tech/star_rcxt/saed32nm_tf_itf_tluplus.map"

set parasitic2 "p2"
set tluplus_file$parasitic2 "$PDK_PATH/tech/star_rcxt/saed32nm_1p9m_Cmin.tluplus"
set layer_map_file$parasitic2 "$PDK_PATH/tech/star_rcxt/saed32nm_tf_itf_tluplus.map"

read_parasitic_tech -tlup $tluplus_filep1 -layermap $layer_map_filep1 -name p1
read_parasitic_tech -tlup $tluplus_filep2 -layermap $layer_map_filep2 -name p2

set_parasitic_parameters -late_spec $parasitic1 -early_spec $parasitic2
set_app_options -name place.coarse.continue_on_missing_scandef -value true


place_opt
legalize_placement
report_congestion
#check_celldensity
#check_pin_density

report_timing -delay_type max
report_timing -delay_type min

set_lib_cell_purpose -include optimization [get_lib_cells {saed32rvt_c/TIEH_RVT saed32rvt_c/TIEL_RVT}]

#This command will search your entire design for any pins that are currently connected to "Logic 1" (VDD) or "Logic 0" (VSS) and replace those connections with the physical Tie cells.

add_tie_cells -objects [get_pins -hierarchical *] -lib_cells {saed32rvt_c/TIEH_RVT saed32rvt_c/TIEL_RVT} -max_fanout 10


#save_block -as full_adder_placement
#save_lib
