R version 4.4.2 (2024-10-31 ucrt) -- "Pile of Leaves"
Copyright (C) 2024 The R Foundation for Statistical Computing
Platform: x86_64-w64-mingw32/x64

R is free software and comes with ABSOLUTELY NO WARRANTY.
You are welcome to redistribute it under certain conditions.
Type 'license()' or 'licence()' for distribution details.

Natural language support but running in an English locale

R is a collaborative project with many contributors.
Type 'contributors()' for more information and
'citation()' on how to cite R or R packages in publications.

Type 'demo()' for some demos, 'help()' for on-line help, or
'help.start()' for an HTML browser interface to help.
Type 'q()' to quit R.

> .libPaths()
[1] "C:/Users/sean.rooney/AppData/Local/R/win-library/4.4"
[2] "C:/Program Files/R/R-4.4.2/library"                  
> getwd() #check working directory 
[1] "C:/Users/sean.rooney"
> library(devtools)
Loading required package: usethis
> devtools::install_github("afsc-gap-products/akgfmaps", build_vignettes = TRUE)
Using GitHub PAT from the git credential store.
Downloading GitHub repo afsc-gap-products/akgfmaps@HEAD
Error in utils::download.file(url, path, method = method, quiet = quiet,  : 
                                download from 'https://api.github.com/repos/afsc-gap-products/akgfmaps/tarball/HEAD' failed
                              > gitcreds::gitcreds_get()$password
                              [1] "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"
                              > install.packages(c("ggplot2",
                                                   +                    "sf",
                                                   +                    "stars",
                                                   +                    "terra"))
                              Error in install.packages : Updating loaded packages
                              > 
                                
                                Restarting R session...
                              
                              > install.packages(c("ggplot2", "sf", "stars", "terra"))
                              Installing packages into ‘C:/Users/sean.rooney/AppData/Local/R/win-library/4.4’
                              (as ‘lib’ is unspecified)
                              also installing the dependency ‘abind’
                              
                              trying URL 'https://cran.rstudio.com/bin/windows/contrib/4.4/abind_1.4-8.zip'
                              Content type 'application/zip' length 67211 bytes (65 KB)
                              downloaded 65 KB
                              
                              trying URL 'https://cran.rstudio.com/bin/windows/contrib/4.4/ggplot2_3.5.1.zip'
                              Content type 'application/zip' length 5021005 bytes (4.8 MB)
                              downloaded 4.8 MB
                              
                              trying URL 'https://cran.rstudio.com/bin/windows/contrib/4.4/sf_1.0-19.zip'
                              Content type 'application/zip' length 41382509 bytes (39.5 MB)
                              downloaded 39.5 MB
                              
                              trying URL 'https://cran.rstudio.com/bin/windows/contrib/4.4/stars_0.6-8.zip'
                              Content type 'application/zip' length 4574082 bytes (4.4 MB)
                              downloaded 4.4 MB
                              
                              trying URL 'https://cran.rstudio.com/bin/windows/contrib/4.4/terra_1.8-21.zip'
                              Content type 'application/zip' length 41931148 bytes (40.0 MB)
                              downloaded 40.0 MB
                              
                              package ‘abind’ successfully unpacked and MD5 sums checked
                              package ‘ggplot2’ successfully unpacked and MD5 sums checked
                              package ‘sf’ successfully unpacked and MD5 sums checked
                              package ‘stars’ successfully unpacked and MD5 sums checked
                              package ‘terra’ successfully unpacked and MD5 sums checked
                              
                              The downloaded binary packages are in
                              C:\Users\sean.rooney\AppData\Local\Temp\RtmpoFKU3W\downloaded_packages
                              > install.packages(c("gstat", "stats", "utils", "methods", "colorspace", "RColorBrewer", "here", "ggspatial", "rmapshaper", "shadowtext", "ggthemes", "classInt", "units"))
                              Warning in install.packages :
                                packages ‘stats’, ‘utils’, ‘methods’ are in use and will not be installed
                              Installing packages into ‘C:/Users/sean.rooney/AppData/Local/R/win-library/4.4’
                              (as ‘lib’ is unspecified)
                              also installing the dependencies ‘xts’, ‘intervals’, ‘geometries’, ‘rapidjsonr’, ‘sfheaders’, ‘zoo’, ‘sftime’, ‘spacetime’, ‘FNN’, ‘rosm’, ‘geojsonsf’, ‘jsonify’
                              
                              
                              There is a binary version available but the source version is later:
                                binary source needs_compilation
                              zoo 1.8-12 1.8-13              TRUE
                              
                              trying URL 'https://cran.rstudio.com/bin/windows/contrib/4.4/xts_0.14.1.zip'
                              Content type 'application/zip' length 1238319 bytes (1.2 MB)
                              downloaded 1.2 MB
                              
                              trying URL 'https://cran.rstudio.com/bin/windows/contrib/4.4/intervals_0.15.5.zip'
                              Content type 'application/zip' length 674280 bytes (658 KB)
                              downloaded 658 KB
                              
                              trying URL 'https://cran.rstudio.com/bin/windows/contrib/4.4/geometries_0.2.4.zip'
                              Content type 'application/zip' length 625656 bytes (610 KB)
                              downloaded 610 KB
                              
                              trying URL 'https://cran.rstudio.com/bin/windows/contrib/4.4/rapidjsonr_1.2.0.zip'
                              Content type 'application/zip' length 161825 bytes (158 KB)
                              downloaded 158 KB
                              
                              trying URL 'https://cran.rstudio.com/bin/windows/contrib/4.4/sfheaders_0.4.4.zip'
                              Content type 'application/zip' length 821044 bytes (801 KB)
                              downloaded 801 KB
                              
                              trying URL 'https://cran.rstudio.com/bin/windows/contrib/4.4/sftime_0.3.0.zip'
                              Content type 'application/zip' length 181993 bytes (177 KB)
                              downloaded 177 KB
                              
                              trying URL 'https://cran.rstudio.com/bin/windows/contrib/4.4/spacetime_1.3-3.zip'
                              Content type 'application/zip' length 2889955 bytes (2.8 MB)
                              downloaded 2.8 MB
                              
                              trying URL 'https://cran.rstudio.com/bin/windows/contrib/4.4/FNN_1.1.4.1.zip'
                              Content type 'application/zip' length 435151 bytes (424 KB)
                              downloaded 424 KB
                              
                              trying URL 'https://cran.rstudio.com/bin/windows/contrib/4.4/rosm_0.3.0.zip'
                              Content type 'application/zip' length 463778 bytes (452 KB)
                              downloaded 452 KB
                              
                              trying URL 'https://cran.rstudio.com/bin/windows/contrib/4.4/geojsonsf_2.0.3.zip'
                              Content type 'application/zip' length 2027346 bytes (1.9 MB)
                              downloaded 1.9 MB
                              
                              trying URL 'https://cran.rstudio.com/bin/windows/contrib/4.4/jsonify_1.2.2.zip'
                              Content type 'application/zip' length 989276 bytes (966 KB)
                              downloaded 966 KB
                              
                              trying URL 'https://cran.rstudio.com/bin/windows/contrib/4.4/gstat_2.1-3.zip'
                              Content type 'application/zip' length 2360522 bytes (2.3 MB)
                              downloaded 2.3 MB
                              
                              trying URL 'https://cran.rstudio.com/bin/windows/contrib/4.4/colorspace_2.1-1.zip'
                              Content type 'application/zip' length 2668480 bytes (2.5 MB)
                              downloaded 2.5 MB
                              
                              trying URL 'https://cran.rstudio.com/bin/windows/contrib/4.4/RColorBrewer_1.1-3.zip'
                              Content type 'application/zip' length 54471 bytes (53 KB)
                              downloaded 53 KB
                              
                              trying URL 'https://cran.rstudio.com/bin/windows/contrib/4.4/here_1.0.1.zip'
                              Content type 'application/zip' length 65013 bytes (63 KB)
                              downloaded 63 KB
                              
                              trying URL 'https://cran.rstudio.com/bin/windows/contrib/4.4/ggspatial_1.1.9.zip'
                              Content type 'application/zip' length 2531536 bytes (2.4 MB)
                              downloaded 2.4 MB
                              
                              trying URL 'https://cran.rstudio.com/bin/windows/contrib/4.4/rmapshaper_0.5.0.zip'
                              Content type 'application/zip' length 1703320 bytes (1.6 MB)
                              downloaded 1.6 MB
                              
                              trying URL 'https://cran.rstudio.com/bin/windows/contrib/4.4/shadowtext_0.1.4.zip'
                              Content type 'application/zip' length 224830 bytes (219 KB)
                              downloaded 219 KB
                              
                              trying URL 'https://cran.rstudio.com/bin/windows/contrib/4.4/ggthemes_5.1.0.zip'
                              Content type 'application/zip' length 472242 bytes (461 KB)
                              downloaded 461 KB
                              
                              trying URL 'https://cran.rstudio.com/bin/windows/contrib/4.4/classInt_0.4-11.zip'
                              Content type 'application/zip' length 503786 bytes (491 KB)
                              downloaded 491 KB
                              
                              trying URL 'https://cran.rstudio.com/bin/windows/contrib/4.4/units_0.8-5.zip'
                              Content type 'application/zip' length 788136 bytes (769 KB)
                              downloaded 769 KB
                              
                              package ‘xts’ successfully unpacked and MD5 sums checked
                              package ‘intervals’ successfully unpacked and MD5 sums checked
                              package ‘geometries’ successfully unpacked and MD5 sums checked
                              package ‘rapidjsonr’ successfully unpacked and MD5 sums checked
                              package ‘sfheaders’ successfully unpacked and MD5 sums checked
                              package ‘sftime’ successfully unpacked and MD5 sums checked
                              package ‘spacetime’ successfully unpacked and MD5 sums checked
                              package ‘FNN’ successfully unpacked and MD5 sums checked
                              package ‘rosm’ successfully unpacked and MD5 sums checked
                              package ‘geojsonsf’ successfully unpacked and MD5 sums checked
                              package ‘jsonify’ successfully unpacked and MD5 sums checked
                              package ‘gstat’ successfully unpacked and MD5 sums checked
                              package ‘colorspace’ successfully unpacked and MD5 sums checked
                              package ‘RColorBrewer’ successfully unpacked and MD5 sums checked
                              package ‘here’ successfully unpacked and MD5 sums checked
                              package ‘ggspatial’ successfully unpacked and MD5 sums checked
                              package ‘rmapshaper’ successfully unpacked and MD5 sums checked
                              package ‘shadowtext’ successfully unpacked and MD5 sums checked
                              package ‘ggthemes’ successfully unpacked and MD5 sums checked
                              package ‘classInt’ successfully unpacked and MD5 sums checked
                              package ‘units’ successfully unpacked and MD5 sums checked
                              
                              The downloaded binary packages are in
                              C:\Users\sean.rooney\AppData\Local\Temp\RtmpoFKU3W\downloaded_packages
                              installing the source package ‘zoo’
                              
                              trying URL 'https://cran.rstudio.com/src/contrib/zoo_1.8-13.tar.gz'
                              Content type 'application/x-gzip' length 773356 bytes (755 KB)
                              downloaded 755 KB
                              
                              * installing *source* package 'zoo' ...
                              ** package 'zoo' successfully unpacked and MD5 sums checked
                              ** using staged installation
                              ** libs
                              using C compiler: 'gcc.exe (GCC) 13.2.0'
                              gcc  -I"C:/PROGRA~1/R/R-44~1.2/include" -DNDEBUG -I../inst/include    -I"C:/rtools44/x86_64-w64-mingw32.static.posix/include"     -O2 -Wall  -mfpmath=sse -msse2 -mstackrealign  -c coredata.c -o coredata.o
                              gcc  -I"C:/PROGRA~1/R/R-44~1.2/include" -DNDEBUG -I../inst/include    -I"C:/rtools44/x86_64-w64-mingw32.static.posix/include"     -O2 -Wall  -mfpmath=sse -msse2 -mstackrealign  -c init.c -o init.o
                              gcc  -I"C:/PROGRA~1/R/R-44~1.2/include" -DNDEBUG -I../inst/include    -I"C:/rtools44/x86_64-w64-mingw32.static.posix/include"     -O2 -Wall  -mfpmath=sse -msse2 -mstackrealign  -c lag.c -o lag.o
                              gcc -shared -s -static-libgcc -o zoo.dll tmp.def coredata.o init.o lag.o -LC:/rtools44/x86_64-w64-mingw32.static.posix/lib/x64 -LC:/rtools44/x86_64-w64-mingw32.static.posix/lib -LC:/PROGRA~1/R/R-44~1.2/bin/x64 -lR
                              installing to C:/Users/sean.rooney/AppData/Local/R/win-library/4.4/00LOCK-zoo/00new/zoo/libs/x64
                              ** R
                              ** demo
                              ** inst
                              ** byte-compile and prepare package for lazy loading
                              ** help
                              *** installing help indices
                              ** building package indices
                              ** installing vignettes
                              ** testing if installed package can be loaded from temporary location
                              ** testing if installed package can be loaded from final location
                              ** testing if installed package keeps a record of temporary installation path
                              * DONE (zoo)
                              
                              The downloaded source packages are in
                              ‘C:\Users\sean.rooney\AppData\Local\Temp\RtmpoFKU3W\downloaded_packages’
                              
                              Restarting R session...
                              
                              > install.packages("C:/Users/sean.rooney/downloads/akgfmaps-4.0.3.tar.gz")
                              Installing package into ‘C:/Users/sean.rooney/AppData/Local/R/win-library/4.4’
                              (as ‘lib’ is unspecified)
                              inferring 'repos = NULL' from 'pkgs'
                              Warning in untar2(tarfile, files, list, exdir, restore_times) :
                                skipping pax global extended headers
                              * installing *source* package 'akgfmaps' ...
                              ** using staged installation
                              ** R
                              ** data
                              *** moving datasets to lazyload DB
                              ** inst
                              ** byte-compile and prepare package for lazy loading
                              ** help
                              *** installing help indices
                              ** building package indices
                              ** installing vignettes
                              ** testing if installed package can be loaded from temporary location
                              ** testing if installed package can be loaded from final location
                              ** testing if installed package keeps a record of temporary installation path
                              * DONE (akgfmaps)
                              > library(akgfmaps)
                              Loading required package: ggplot2
                              Loading required package: sf
                              Linking to GEOS 3.13.0, GDAL 3.10.1, PROJ 9.5.1; sf_use_s2() is TRUE
                              Loading required package: stars
                              Loading required package: abind
                              Loading required package: terra
                              terra 1.8.21
                              > ?get_base_layers
                              > sebs <- get_base_layers(select.region = "sebs",
                                                        +                         set.crs = "EPSG:3338")
                              > 
                                > ggplot() +
                                +     geom_sf(data = sebs$akland) +
                                +     geom_sf(data = sebs$survey.strata,
                                              +             fill = NA,
                                              +             mapping = aes(color = "Survey strata")) +
                                +     geom_sf(data = sebs$survey.grid,
                                              +             fill = NA,
                                              +             mapping = aes(color = "Station grid")) +
                                +     geom_sf(data = sebs$survey.area,
                                              +             fill = NA,
                                              +             mapping = aes(color = "Survey area")) +
                                +     geom_sf(data = sebs$graticule, alpha = 0.3, linewidth = 0.5) +
                                +     scale_x_continuous(limits = sebs$plot.boundary$x,
                                                         +                        breaks = sebs$lon.breaks) +
                                +     scale_y_continuous(limits = sebs$plot.boundary$y,
                                                         +                        breaks = sebs$lat.breaks) +
                                +     theme_bw()
                              