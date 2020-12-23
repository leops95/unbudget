cd "~/GitHub/unbudget"

//ssc install fre // useful for reading long value labels


** IMPORT COUNTRY PAYMENTS
import excel "data/unbudget.xlsx", sheet("contrib_date") firstrow clear


** EXRTACT DATE
gen year = year(date)
gen month = month(date)
gen day = day(date)


** HARMONIZE COUNTRY NAMES WITH ISO FILE
replace cname = "Bolivia (Plurinational State of)" if cname == "Bolivia"
replace cname = "Bosnia Herzegovina" if(cname == "Bosnia & Herzegovina" | cname == "Bosnia and Herzegovinia" | cname == "Bosnia and Herzegovina")
replace cname = "Cabo Verde" if cname == "Cape Verde"
replace cname = "Central African Rep." if cname == "Central African Republic"
replace cname = "Côte d'Ivoire" if(cname == "Cote D'Ivoire"|cname == "Cote d'Ivoire" | cname == "Côte d’Ivoire")
replace cname = "Congo" if(cname == "Congo (Republic)" | cname == "Republic of Congo")
replace cname = "Czechia" if cname == "Czech Republic"
replace cname = "Dem. People's Rep. of Korea" if(cname == "Democratic People's Republic of Korea" | cname == "DPR of Korea" | cname == "Democratic People’s Republic of Korea")
replace cname = "Dem. Rep. of the Congo" if(cname == "Democratic Republic of the Congo" | cname == "Democratic Republic of Congo")
replace cname = "Dominican Rep." if cname == "Dominican Republic"
replace cname = "FS Micronesia" if cname == "Federated States of Micronesia" | cname == "Micronesia (Federated States of)"
replace cname = "Holy See (Vatican City State)" if cname == "Holy See"
replace cname = "Kazakhstan" if cname == "Kazakhastan"
replace cname = "Kyrgyzstan" if cname == "Kyrgyz Republic"
replace cname = "Lao People's Dem. Rep." if(cname == "Lao People's Democratic Republic" | cname == "Laos" | cname == "Lao People’s Democratic Republic")
replace cname = "Libya" if(cname == "Libyan Arab Jamahiriya" | cname == "Libyan Arab Jamahariya")
replace cname = "Marshall Isds" if cname == "Marshall Islands"
replace cname = "FS Micronesia" if cname == "Micronesia"
replace cname = "TFYR of Macedonia" if(cname == "North Macedonia" | cname == "The former Yugoslav Republic of Macedonia")
replace cname = "Rep. of Korea" if cname == "Republic of Korea"
replace cname = "Rep. of Moldova" if(cname == "Republic of Moldova" | cname == "Moldova")
replace cname = "Russian Federation" if cname == "Russsian Federation"
replace cname = "Saint Kitts and Nevis" if(cname == "St Kitts and Nevis" | cname == "St. Kitts and Nevis")
replace cname = "Saint Lucia" if cname == "St Lucia"
replace cname = "Slovakia" if cname == "Slovak Republic"
replace cname = "Solomon Isds" if cname == "Solomon Islands"
replace cname = "Sri Lanka" if cname == "Sir Lanka"
replace cname = "Swaziland" if cname == "Eswatini"
replace cname = "Syria" if cname == "Syrian Arab Republic"
replace cname = "Timor-Leste" if cname == "Timor Leste"
replace cname = "United Rep. of Tanzania" if(cname == "United Republic of Tanzania" | cname == "Tanzania")
replace cname = "United Kingdom" if cname == "United Kingdom of Great Britain and Northern Ireland"
replace cname = "Venezuela" if cname == "Venezuela (Bolivarian Republic of)"
replace cname = "Viet Nam" if(cname == "Vietnam")

bysort cname year: gen dup = cond(_N == 1, 0, _n)
tab dup // good if no duplicates
drop if dup == 2 // Philippines appears twice ! Drop the second one
drop dup

tempfile ontime
save `ontime'


** ADD COUNTRY CODES
import delimited data/iso_country_codes.csv, clear // copy from my cow2iso repository
keep countrynameabbreviation iso3digitalpha
rename countrynameabbreviation cname
rename iso3digitalpha iso3

tempfile isocodes
save `isocodes'

use `ontime', replace

merge m:1 cname using `isocodes' // Monaco and Liechtenstein does not exist in my list
drop if _merge == 2
drop _merge

replace iso3 = "MCO" if cname == "Monaco"
replace iso3 = "LIE" if cname == "Liechtenstein"

tab cname if iso3 == "" // good if no obervations

tempfile clean_ontime_long
save `clean_ontime_long'


** IMPORT COUNTRY ASSESSMENTS
import excel "data/unbudget.xlsx", sheet("contrib_assess") firstrow clear


** HARMONIZE COUNTRY NAMES WITH ISO FILE
replace cname = "Bolivia (Plurinational State of)" if cname == "Bolivia"
replace cname = "Bosnia Herzegovina" if(cname == "Bosnia and Herzegovina")
replace cname = "Cabo Verde" if cname == "Cape Verde"
replace cname = "Central African Rep." if cname == "Central African Republic"
replace cname = "Czechia" if cname == "Czech Republic"
replace cname = "Côte d'Ivoire" if(cname == "CÃ´te dâ€™Ivoire" | cname == "Côte d’Ivoire")
replace cname = "Dem. People's Rep. of Korea" if(cname == "Democratic People’s Republic of Korea" | cname == "Democratic Peopleâ€™s Republic of Korea" | cname == "Democratic People's Republic of Korea")
replace cname = "Dem. Rep. of the Congo" if(cname == "Democratic Republic of the Congo")
replace cname = "Dominican Rep." if cname == "Dominican Republic"
replace cname = "Iran" if cname == "Iran (Islamic Republic of)"
replace cname = "Lao People's Dem. Rep." if(cname == "Lao People’s Democratic Republic" | cname == "Lao Peopleâ€™s Democratic Republic" | cname == "Lao People's Democratic Republic")
replace cname = "Libya" if cname == "Libyan Arab Jamahiriya"
replace cname = "TFYR of Macedonia" if(cname == "North Macedonia" | cname == "The former Yugoslav Republic of Macedonia" | cname == "Macedonia")
replace cname = "Marshall Isds" if cname == "Marshall Islands"
replace cname = "FS Micronesia" if cname == "Micronesia (Federated States of)"
replace cname = "Rep. of Korea" if cname == "Republic of Korea"
replace cname = "Rep. of Moldova" if(cname == "Republic of Moldova" | cname == "Moldova (Republic of)" | cname == "Moldova")
replace cname = "Solomon Isds" if cname == "Solomon Islands"
replace cname = "Swaziland" if cname == "Eswatini"
replace cname = "Syria" if cname == "Syrian Arab Republic"
replace cname = "United Rep. of Tanzania" if(cname == "United Republic of Tanzania")
replace cname = "United Kingdom" if cname == "United Kingdom of Great Britain and Northern Ireland"
replace cname = "USA" if cname == "United States of America"
replace cname = "Venezuela" if cname == "Venezuela (Bolivarian Republic of)"

//drop if cname == "Yugoslavia"

fre cname, all // must all have same number of observations

merge m:1 cname using `isocodes' // Monaco and Liechtenstein does not exist in my list
drop if _merge == 2
drop _merge

replace iso3 = "MCO" if cname == "Monaco"
replace iso3 = "LIE" if cname == "Liechtenstein"

tab cname if iso3 == "" // good if no obervations

drop gross_assess credit comments
order cname iso3 year
sort cname year


** MERGE WITH PAYMENTS
merge 1:1 iso3 year using `clean_ontime_long'
drop if _merge == 2
drop _merge

replace ontime = 2 if ontime == 1 // paid on time
replace ontime = 1 if ontime == 0 // paid late
replace ontime = 0 if ontime == . // did not pay in full during the year
gen ontime_str = "Not paid in full" if ontime == 0
replace ontime_str = "Paid late" if ontime == 1
replace ontime_str = "Paid on time" if ontime == 2

generate net_assess_str = net_assess
tostring net_assess_str, replace
generate part1 = substr(net_assess_str, -3, 3)
generate part2 = substr(net_assess_str, -6, 3)
replace part2 = substr(net_assess_str, -5, 2) if part2 == ""
generate part3 = substr(net_assess_str, -9, 3)
replace part3 = substr(net_assess_str, -8, 2) if part3 == ""
replace part3 = substr(net_assess_str, -7, 1) if part3 == ""

replace net_assess_str = part3 + "'" + part2 + "'" + part1 if part3 != ""
replace net_assess_str = part2 + "'" + part1 if(part2 != "" & part3 == "")
drop part*

order cname iso3 year scale net_assess net_assess_str ontime ontime_str date
sort cname year
label variable cname
label variable iso3
label variable year
label variable scale
label variable net_assess
label variable ontime
label variable date

** DUPLICATE OBSERVATIONS FOR YUGOSLAVIA AND FORMER SUDAN
expand 3
bysort cname year: gen dup = cond(_N == 1, 0 , _n)
drop if dup > 1 & cname != "Yugoslavia" & cname != "Sudan" & cname != "Serbia and Montenegro"
sort iso3 year
replace iso3 = "SRB" if cname == "Serbia and Montenegro" & dup == 1
replace iso3 = "MNE" if cname == "Serbia and Montenegro" & dup == 2
replace iso3 = "KOS" if cname == "Serbia and Montenegro" & dup == 3 & year <= 2008
replace iso3 = "SRB" if cname == "Yugoslavia" & dup == 1
replace iso3 = "MNE" if cname == "Yugoslavia" & dup == 2
replace iso3 = "KOS" if cname == "Yugoslavia" & dup == 3
replace iso3 = "SSD" if cname == "Sudan" & dup == 2
drop if dup == 3 & iso3 != "KOS"
drop dup

** RENAME COUNTRIES TO ACTUAL NAMES
replace cname = "Bosnia and Herzegovina" if cname == "Bosnia Herzegovina"
replace cname = "Bolivia" if cname == "Bolivia (Plurinational State of)"
replace cname = "Central African Republic" if cname == "Central African Rep."
replace cname = "Congo, Republic Democratic of" if cname == "Dem. Rep. of the Congo"
replace cname = "Congo, Republic of the" if cname == "Congo"
replace cname = "Cape Verde" if cname == "Cabo Verde"
replace cname = "Dominican Republic" if cname == "Dominican Rep."
replace cname = "Micronesia" if cname == "FS Micronesia"
replace cname = "Korea, South" if cname == "Rep. of Korea"
replace cname = "Laos" if cname == "Lao People's Dem. Rep."
replace cname = "Moldova" if cname == "Rep. of Moldova"
replace cname = "Marshall Islands" if cname == "Marshall Isds"
replace cname = "North Macedonia" if cname == "TFYR of Macedonia"
replace cname = "Korea, North" if cname == "Dem. People's Rep. of Korea"
replace cname = "Solomon Islands" if cname == "Solomon Isds"
replace cname = "East Timor" if cname == "Timor-Leste"
replace cname = "Tanzania" if cname == "United Rep. of Tanzania"
replace cname = "United States" if cname == "USA"
replace cname = "Vietnam" if cname == "Viet Nam"
sort cname year

** EXPORT COUNTRY PAYMENTS
preserve
drop month day contrib
tostring inexact_date, replace
rename inexact_date exact_date
replace exact_date = "Yes" if exact_date == "0"
replace exact_date = "No" if exact_date == "1"
replace exact_date = "" if exact_date == "."
save data/clean_all_long.dta, replace
restore

** GENERATE MONTHLY NUMBER OF COUNTRIES WHO PAID
keep iso3 year month net_assess
egen iso_int = group(iso3)
drop iso3

bysort year: egen total_contrib = sum(net_assess) //max(sum(net_assess))
replace net_assess = net_asses / total_contrib

collapse (count) iso_int (sum) net_assess, by(year month)
rename iso_int nb_paid

drop if month == . // did not pay

sort year month
bysort year: gen share_paid = sum(net_assess)


tempfile month_data
save `month_data'


** GENERATE YEAR-MONTH SKELETON
clear
input month
1
2
3
4
5
6
7
8
9
10
11
12
end
expand 21
bysort month:gen year=1999+_n
order year month
sort year month


** MERGE DATA ON SKELETON
merge 1:1 year month using `month_data'
drop _merge

replace nb_paid = 0 if nb_paid == .
replace net_assess = net_assess[_n-1] if net_assess[_n] == .
replace share_paid = share_paid[_n-1] if share_paid[_n] == .

bysort year (month): gen tot_paid = sum(nb_paid)


** DROP EMPTY MONTHS (MISSING VALUES, SHOULD NOT BE EQUAL TO ZERO)
drop if(year == 2006 &(month == 10 | month == 11 | month == 12))
drop if(year == 2009 &(month == 10 | month == 11 | month == 12))
drop if(year == 2010 & month == 12)
drop if(year == 2013 &(month == 11 | month == 12))
drop if(year == 2018 &(month == 11 | month == 12))

rename tot_paid cumul_paid
rename share_paid cumul_share_paid
rename net_assess share_paid

replace share_paid = round(share_paid * 100, 0.01)
replace cumul_share_paid = round(cumul_share_paid * 100, 0.01)

order year month nb_paid cumul_paid share_paid cumul_share_paid
sort year month

label variable nb_paid
label variable share_paid

recast double cumul_share_paid

** EXPORT MONTHLY PAYMENTS
save data/clean_nb_month.dta, replace