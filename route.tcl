#######################################################
# set app options
#########################################################
#
#global route
set_app_options -name route.global.timing_driven -value true
set_app_options -name route.global.crosstalk_driven -value false


#track assignment
set_app_options -name route.track.timing_driven -value true
set_app_options -name route.track.crosstalk_driven -value true
#

#detail route 
set_app_options -name route.detail.timing_driven -value true
#chnaged
set_app_options -name route.detail.force_max_number_iterations -value false
set_app_options -name route.detail.antenna -value true
set_app_options -name route.detail.antenna_fixing_preference -value use_diodes
set_app_options -name route.detail.diode_libcell_names -value */ANTENNA_RVT
#

####################################
#Atomic commands for route_auto
###################################
route_global
#save_block route_global_database

route_track
#save_block route_track_database

route_detail
#save_block route_detail_database

#route_auto
#
#
#
route_opt

report_timing -delay_type min -path_type full_clock -max_paths 5 -significant_digits 6

report_timing -delay_type min -max_paths 50 -significant_digits 6

######################################
# OUTPUTS
#
#
write_verilog ./fifo.routed.v



write_parasitics -format spef -output ./fifo_${scenario1}.spef 

write_gds fifo_final.gds
#
