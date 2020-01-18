#
# $argv is passed from called
# this design_name is like a return variable..
#

#
# $argv is set by the caller
#
set dst_dir $argv
set design_name clock

# Proc to create BD clock
# The auto-generated proc only has 1 argc
# I added 2 more for name and dir
proc cr_bd_clock { parentCell dst_dir design_name } {

  # CHANGE DESIGN NAME HERE
  set design_name clock

  common::send_msg_id "BD_TCL-003" "INFO" "Currently there is no design <$design_name> in project, so creating one..."

  #create_bd_design $design_name
  create_bd_design $design_name -dir $dst_dir

  set bCheckIPsPassed 1
  ##################################################################
  # CHECK IPs
  ##################################################################
  set bCheckIPs 1
  if { $bCheckIPs == 1 } {
     set list_check_ips "\ 
  xilinx.com:ip:clk_wiz:6.0\
  "

   set list_ips_missing ""
   common::send_msg_id "BD_TCL-006" "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_msg_id "BD_TCL-115" "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

  }

  if { $bCheckIPsPassed != 1 } {
    common::send_msg_id "BD_TCL-1003" "WARNING" "Will not continue with creation of design due to the error(s) above."
    return 3
  }

  variable script_folder

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set sysclk_125 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 sysclk_125 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {125000000} \
   ] $sysclk_125


  # Create ports
  set clk_out1_0 [ create_bd_port -dir O -type clk clk_out1_0 ]

  # Create instance: clk_wiz_0, and set properties
  set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_0 ]
  set_property -dict [ list \
   CONFIG.CLK_IN1_BOARD_INTERFACE {sysclk_125} \
   CONFIG.USE_BOARD_FLOW {true} \
   CONFIG.USE_LOCKED {false} \
   CONFIG.USE_RESET {false} \
 ] $clk_wiz_0

  # Create interface connections
  connect_bd_intf_net -intf_net sysclk_125_1 [get_bd_intf_ports sysclk_125] [get_bd_intf_pins clk_wiz_0/CLK_IN1_D]

  # Create port connections
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_ports clk_out1_0] [get_bd_pins clk_wiz_0/clk_out1]

  # Create address segments

  # Perform GUI Layout
  regenerate_bd_layout -layout_string {
   "ExpandedHierarchyInLayout":"",
   "guistr":"# # String gsaved with Nlview 7.0.19  2019-03-26 bk=1.5019 VDI=41 GEI=35 GUI=JA:9.0 TLS
#  -string -flagsOSRD
preplace port sysclk_125 -pg 1 -lvl 0 -x 0 -y 60 -defaultsOSRD
preplace port clk_out1_0 -pg 1 -lvl 2 -x 280 -y 70 -defaultsOSRD
preplace inst clk_wiz_0 -pg 1 -lvl 1 -x 140 -y 70 -defaultsOSRD
preplace netloc clk_wiz_0_clk_out1 1 1 1 N 70
preplace netloc sysclk_125_1 1 0 1 20J 60n
levelinfo -pg 1 0 140 280
pagesize -pg 1 -db -bbox -sgen -130 0 410 140
"
}

  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
  close_bd_design $design_name 
}

# Invoke the above defined proc
cr_bd_clock "" $dst_dir $design_name
