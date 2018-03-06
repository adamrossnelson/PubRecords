// Routine to find sample for IPEDS pub records research project.
// Mar 03 2018     Adam Ross Nelson     Initial build
// Mar 05 2018     Adam Ross Nelson     Added to GitHub

set more off
clear all

use IPEDSDirInfo02to16.dta
merge 1:1 unitid isYr using IPEDS12MoEnrl02to16.dta, gen(enrlmatch)
keep if enrlmatch == 3
merge 1:1 unitid isYr using IPEDSInstChar02to16.dta, gen(charmatch)
keep if charmatch == 3
numlabel, add

keep if sector == 1 & isYr == 2016

merge 1:1 unitid isYr using IPEDSInstChar02to16.dta, nogen

keep if roomcap < .
keep if efytotltugr < .
keep if fips < 60

gen sturoomrt = roomcap / efytotltugr
sum efytotltugr, detail
sum roomcap, detail
sum sturoomrt, detail

count if sturoomrt > .15 & sturoomrt < .37

gsort stabbr -sturoomrt

by stabbr, sort : egen float sturoomrk = rank(sturoomrt), field

export excel unitid instnm chfnm chftitle addr city ///
stabbr zip roomcap efytotltugr sturoomrt using ///
"P:\pCloud Sync\Box Docs\JusticeAdmResearch\sp_lst.xlsx" ///
if sturoomrk == 1, firstrow(variables) replace

