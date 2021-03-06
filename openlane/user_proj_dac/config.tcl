# SPDX-FileCopyrightText: 2020 Efabless Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# SPDX-License-Identifier: Apache-2.0

set script_dir [file dirname [file normalize [info script]]]

set ::env(DESIGN_NAME) user_proj_dac

set ::env(VERILOG_FILES) "\
	$::env(CARAVEL_ROOT)/verilog/rtl/defines.v \
	$script_dir/../../verilog/rtl/user_proj_dac.v \
	$script_dir/../../verilog/rtl/audiodac*.v \
	$script_dir/../../verilog/rtl/stud*.v"

# this takes long, only for final run
#set ::env(LEC_ENABLE) 1

set ::env(DESIGN_IS_CORE) 0

# Set clock details
set ::env(CLOCK_PORT) {user_clock2}
set ::env(CLOCK_PERIOD) "50"

# Design has hold violations, trying this to fix it
set ::env(PL_RESIZER_HOLD_SLACK_MARGIN) "0.7"
set ::env(GLB_RESIZER_HOLD_SLACK_MARGIN) "0.7"

# Setup placing and routing
set ::env(FP_SIZING) absolute
set ::env(DIE_AREA) "0 0 1200 2000"
set ::env(FP_CORE_UTIL) 25
set ::env(PL_TARGET_DENSITY) [ expr ($::env(FP_CORE_UTIL)+5) / 100.0 ]
set ::env(ROUTING_CORES) 4

# Need to blacklist decap_12, otherwise LI1 density too high in Caravel
#set ::env(DECAP_CELL) "\
#	sky130_fd_sc_hd__decap_3 \
#	sky130_fd_sc_hd__decap_4 \
#	sky130_fd_sc_hd__decap_6 \
#	sky130_fd_sc_hd__decap_8 \
#	sky130_ef_sc_hd__decap_12"

# Pin config
set ::env(FP_PIN_ORDER_CFG) $script_dir/pin_order.cfg

# Maximum layer used for routing is metal 4.
# This is because this macro will be inserted in a top level (user_project_wrapper) 
# where the PDN is planned on metal 5. So, to avoid having shorts between routes
# in this macro and the top level metal 5 stripes, we have to restrict routes to metal4.  
set ::env(GLB_RT_MAXLAYER) 5

# You can draw more power domains if you need to 
set ::env(VDD_NETS) [list {vccd1}]
set ::env(GND_NETS) [list {vssd1}]

set ::env(DIODE_INSERTION_STRATEGY) 4 
# If you're going to use multiple power domains, then disable cvc run.
set ::env(RUN_CVC) 1
