
set target_library ./../ref/lib/stdcell_rvt/saed32rvt_tt0p78vn40c.db 
set link_library ./../ref/lib/stdcell_rvt/saed32rvt_tt0p78vn40c.db
       
set RTL_SOURCE_FILES ./../design/fifo.v
set DESIGN_NAME fifo

define_design_lib WORK -path ./WORK
set_app_var hdlin_enable_hier_map true
analyze -format verilog ${RTL_SOURCE_FILES}
elaborate ${DESIGN_NAME}
link      
current_design
read_sdc ./../design/fifo.sdc

set_verification_top     

compile_ultra 

report_timing -delay_type min > hold.rpt
      
report_timing -delay_type max > setup.rpt
     
report_qor > qor.rpt
report_area > area.rpt
report_power > power.rpt

write_sdc fifo_synthesis.sdc
