;; =================================
;;
;; This is a program to plot topography and wind data (wind barbs) 
;; from raw WRF output (from a NetCDF file)
;; 
;; Created by K Zigner
;; April 2020
;; 
;; =================================

; To run entire program from the IDL command line, run the command below
;.run '/home/zigner/idl_programs/mapgrid_labels.pro' '/home/zigner/idl_programs/GertJan_April2020_WRF_wind_plot.pro'


;;; INPUT  ;;;

; WRF NetCDF file

;infile = '/home/sbarc/wrf/wrf401/sundowners/20170311/run-64452560-z0-1way/wrfout_d04_2017-03-10_18:00:00' ; March 2019
infile = '/home/sbarc/wrf/wrf401/sundowners/swex-0/run-64452560-z0-1way/wrfout_d04_2018-04-27_18:00:00' ; SWEX

; Define whether WRF should convert to PST (-8) or PDT (-7);
; only one of the below should be 1, the other should be 0

PDT = 0
PST = 1

; Define the day and time to create the plot 
; (in local PST or PDT, defined above)

day1  = 28
hour1 = 20

; Add a prefix for the title of the plot

;title1 = 'Eastern Regime'     ; March 2017 
title1 = 'Western Regime'     ; SWEX

; Option to save the resulting plot (0 = no, 1 = yes)

save_plot = 1

; Path and name for plot

outfile = '/home/sbarc/students/zigner/misc/SWEX_WRF_wind_plot_20PST.png'


;;; END INPUT OPTIONS ;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; RUN CODE BELOW ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; read in WRF output 
id = NCDF_OPEN(infile)

; extract data for longitude, latitude, elevation, 
; land use, wind (u and v), and time

; define the names of the variables to extract
; can use ncdump to get the names
lo_id = NCDF_VARID(id, 'XLONG')
la_id = NCDF_VARID(id, 'XLAT')
h_id  = NCDF_VARID(id, 'HGT')
w_id  = NCDF_VARID(id, 'LU_INDEX')
u_id  = NCDF_VARID(id, 'U10')
v_id  = NCDF_VARID(id, 'V10')
t_id  = NCDF_VARID(id, 'Times') ; in UTC

; extract the data
NCDF_VARGET, id, lo_id, rlon
NCDF_VARGET, id, la_id, rlat
NCDF_VARGET, id, h_id,  hgt
NCDF_VARGET, id, w_id,  lu
NCDF_VARGET, id, u_id,  u10
NCDF_VARGET, id, v_id,  v10
NCDF_VARGET, id, t_id,  times

;;;

; make the lon.s and lat.s 1D variables

lons = reform(rlon[*,0])
lats = reform(rlat[0,*])

mlon = n_elements(lons)
mlat = n_elements(lats)

;;; 

; use the land use variable to identify land/ water
; water is number 17
land_mask = float(lu[*,*,0])
land_mask[where(land_mask lt 17.)] = !Values.F_NAN ; all non-water values
land_mask[where(land_mask eq 17.)] = 1.            ; all water values


;;;

; time variable is in string format and includes 
; both the time and date
; have to extract year, month, day, and hour 
; based on the locations within the strings
times_utc = string(times)
wyear_utc = fix(strmid(times_utc, 0,4))
wmon_utc  = fix(strmid(times_utc, 5,2))
wday_utc  = fix(strmid(times_utc, 8,2))
whour_utc = fix(strmid(times_utc, 11,2))
wmin_utc  = fix(strmid(times_utc, 14,2))
wtot      = n_elements(wday_utc)

; convert to PST or PDT using commands JULDAY and CALDAT
jul_utc   = JULDAY(wmon_utc, wday_utc, wyear_utc, whour_utc, wmin_utc)
IF PST eq 1 THEN CALDAT, (jul_utc-(7.99/24.)), wmon, wday, wyear, whour, wmin
   ; ^^ if I do 8./24. I get two 2300 hours... small bug in the language
IF PDT eq 1 THEN CALDAT, (jul_utc-(7./24.)), wmon, wday, wyear, whour, wmin

;;;

; subset the data based on lon.s, lat.s, and time 
; (specified in the options)

; set bounds for lon.s and lat.s
lo1 = -120.3
lo2 = -119.3
la1 = 34.3
la2 = 34.7

; identify indices for the lon.s and lat.s above
xx1 = where(abs(lons-lo1) eq min(abs(lons-lo1)))
xx2 = where(abs(lons-lo2) eq min(abs(lons-lo2)))
yy1 = where(abs(lats-la1) eq min(abs(lats-la1)))
yy2 = where(abs(lats-la2) eq min(abs(lats-la2)))


; determine where the specified time is found in the arrays
tt1 = where(wday eq day1 and whour eq hour1)

;;;

; apply the spatial and temporal subset to the variables
lon_sub = lons[xx1:xx2]
lat_sub = lats[yy1:yy2]
hgt_sub = hgt[xx1:xx2, yy1:yy2, tt1]
u10_sub = u10[xx1:xx2, yy1:yy2, tt1]
v10_sub = v10[xx1:xx2, yy1:yy2, tt1]
land_mask_sub = land_mask[xx1:xx2, yy1:yy2]

mlon = n_elements(lons)
mlat = n_elements(lats)

;;; 

; mask out ocean values in elevation variable
hgt_sub[where(land_mask_sub eq 1.)] = !Values.F_NAN

;;;

; calculate wind speed
wspd_sub = sqrt(u10_sub^2. + v10_sub^2.)

; convert from m/s into kts
u10_sub_kt  = u10_sub*1.94384
v10_sub_kt  = v10_sub*1.94384
wspd_sub_kt = wspd_sub*1.94384

;;;

; create the time variable as a string in PDT for the plot title
IF pst eq 1 THEN time_name = strcompress(string(wyear[tt1]) + '-' + $
                    string(wmon[tt1]) + '-' + string(wday[tt1]) + '_' + $
                    string(whour[tt1]) + 'PST', /remove_all)

IF pdt eq 1 THEN time_name = strcompress(string(wyear[tt1]) + '-' + $
                    string(wmon[tt1]) + '-' + string(wday[tt1]) + '_' + $
                    string(whour[tt1]) + 'PDT', /remove_all)

;;;

; define colortable for elevation
ct = COLORTABLE(74, /reverse)

; plot the elevation (colored) and winds (barbs) for the subset

; open a new window for the plot
w = WINDOW(dimensions=[1200,500])
m = map('GEOGRAPHIC', /current, linestyle=1, position=[80,50,1100,430], /device, $
   limit=[min(lat_sub),min(lon_sub),max(lat_sub),max(lon_sub)])

; plot topography for regional subset
p1 = image(hgt_sub, lon_sub, lat_sub, overplot=m, rgb_table=ct, font_size=20, $
   title = title1 + ' - ' + time_name)
c1 = contour(hgt_sub, lon_sub, lat_sub, overplot=m, c_value=indgen(6)*400, $
   color='black', c_label_show=0, c_thick=1)

p1.title.font_size = 20
br = mapcontinents(/HIRES, /USA, thick=2)
m.mapgrid.label_position=0
m.mapgrid.label_angle=0
m.mapgrid.font_size=16
m.mapgrid.label_format='Mapgrid_Labels'
m.mapgrid.grid_latitude=6./60.
m.mapgrid.grid_longitude=12./60.

; add the colorbar and title
colb  = colorbar(target=p1, orientation=1, position=[1100,75,1124,395], /device, $
   textpos=1, font_size=16, taper=1)
text1 = TEXT(1130, 435, 'Elev. (m)', /device, alignment=0.5, font_style=2, font_size=16)

; plot wind vectors
vec1  = VECTOR(u10_sub_kt, v10_sub_kt, lon_sub, lat_sub, overplot=m, vector_style=1, $
   x_subsample=3, y_subsample=3, thick=2, length_scale=1.2, head_size=2)

; option to save the file
IF save_plot eq 1 THEN w.SAVE, outfile
IF save_plot eq 1 THEN w.CLOSE


END ; end the program 
