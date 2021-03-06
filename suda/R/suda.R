#' Color palette generate for suda
#'
#' This will return n colors for graphic functions in the book.
#' 
#' Brief description
#' 
#' @param n number of colors to return
#' @param type type of color palette (dev, seq, qual)
#' @author Jay Jacobs
#' @keywords palette
#' @export
#' @examples
#'   color.values <- suda.pal(3, "div")
suda.pal <- function(n, type="seq") {
  if(!(type %in% c("div", "seq", "qual"))){
    stop(paste(type,"is not a valid type of palette name for suda.pal\n"))
  }   
  if(n<3) { 
    warning("minimal value for n is 3, returning requested palette with 3 different levels\n")
    return(suda.pal(3,type))
  }
  
  switch(type,        
         # was Blues
         seq = switch(n-2,            
                      rgb(c(222,158,49),
                          c(235,202,130),
                          c(247,225,189),maxColorValue=255),
                      rgb(c(239,189,107,33),
                          c(243,215,174,113),
                          c(255,231,214,181),maxColorValue=255),
                      rgb(c(239,189,107,49,8),
                          c(243,215,174,130,81),
                          c(255,231,214,189,156),maxColorValue=255),
                      rgb(c(239,198,158,107,49,8),
                          c(243,219,202,174,130,81),
                          c(255,239,225,214,189,156),maxColorValue=255),
                      rgb(c(239,198,158,107,66,33,8),
                          c(243,219,202,174,146,113,69),
                          c(255,239,225,214,198,181,148),maxColorValue=255),
                      rgb(c(247,222,198,158,107,66,33,8),
                          c(251,235,219,202,174,146,113,69),
                          c(255,247,239,225,214,198,181,148),maxColorValue=255),
                      rgb(c(247,222,198,158,107,66,33,8,8),
                          c(251,235,219,202,174,146,113,81,48),
                          c(255,247,239,225,214,198,181,156,107),maxColorValue=255)
         ), 
         # was BrBG
         div = switch(n-2,            
                      rgb(c(216,245,90),
                          c(179,245,180),
                          c(101,245,172),maxColorValue=255),
                      rgb(c(166,223,128,1),
                          c(97,194,205,133),
                          c(26,125,193,113),maxColorValue=255),
                      rgb(c(166,223,245,128,1),
                          c(97,194,245,205,133),
                          c(26,125,245,193,113),maxColorValue=255),
                      rgb(c(140,216,246,199,90,1),
                          c(81,179,232,234,180,102),
                          c(10,101,195,229,172,94),maxColorValue=255),
                      rgb(c(140,216,246,245,199,90,1),
                          c(81,179,232,245,234,180,102),
                          c(10,101,195,245,229,172,94),maxColorValue=255),
                      rgb(c(140,191,223,246,199,128,53,1),
                          c(81,129,194,232,234,205,151,102),
                          c(10,45,125,195,229,193,143,94),maxColorValue=255),
                      rgb(c(140,191,223,246,245,199,128,53,1),
                          c(81,129,194,232,245,234,205,151,102),
                          c(10,45,125,195,245,229,193,143,94),maxColorValue=255),
                      rgb(c(84,140,191,223,246,199,128,53,1,0),
                          c(48,81,129,194,232,234,205,151,102,60),
                          c(5,10,45,125,195,229,193,143,94,48),maxColorValue=255),
                      rgb(c(84,140,191,223,246,245,199,128,53,1,0),
                          c(48,81,129,194,232,245,234,205,151,102,60),
                          c(5,10,45,125,195,245,229,193,143,94,48),maxColorValue=255)
         ),  
         # was Set3
         qual =  switch(n-2, 
                        rgb(c(141,255,190),
                            c(211,255,186),
                            c(199,179,218),maxColorValue=255),
                        rgb(c(141,255,190,251),
                            c(211,255,186,128),
                            c(199,179,218,114),maxColorValue=255),
                        rgb(c(141,255,190,251,128),
                            c(211,255,186,128,177),
                            c(199,179,218,114,211),maxColorValue=255),
                        rgb(c(141,255,190,251,128,253),
                            c(211,255,186,128,177,180),
                            c(199,179,218,114,211,98),maxColorValue=255),
                        rgb(c(141,255,190,251,128,253,179),
                            c(211,255,186,128,177,180,222),
                            c(199,179,218,114,211,98,105),maxColorValue=255),
                        rgb(c(141,255,190,251,128,253,179,252),
                            c(211,255,186,128,177,180,222,205),
                            c(199,179,218,114,211,98,105,229),maxColorValue=255),
                        rgb(c(141,255,190,251,128,253,179,252,217),
                            c(211,255,186,128,177,180,222,205,217),
                            c(199,179,218,114,211,98,105,229,217),maxColorValue=255),
                        rgb(c(141,255,190,251,128,253,179,252,217,188),
                            c(211,255,186,128,177,180,222,205,217,128),
                            c(199,179,218,114,211,98,105,229,217,189),maxColorValue=255),
                        rgb(c(141,255,190,251,128,253,179,252,217,188,204),
                            c(211,255,186,128,177,180,222,205,217,128,235),
                            c(199,179,218,114,211,98,105,229,217,189,197),maxColorValue=255),
                        rgb(c(141,255,190,251,128,253,179,252,217,188,204,255),
                            c(211,255,186,128,177,180,222,205,217,128,235,237),
                            c(199,179,218,114,211,98,105,229,217,189,197,111),maxColorValue=255)
         ))  
}                        

#' Convert latitude/longitude pairs to areas from a map
#'
#' Given a data frame of lat and long pairs and a map type to load,
#' this will convert the location to the region of the map.
#' code is adapted from a gist on github
#' https://gist.github.com/rweald/4720788
#'
#' @param pointsDF a data frame with long, lat in the columns
#' @param mapping the map to load ("world", "states", "county")
#' @author Jay Jacobs
#' @keywords map
#' @export
#' @import maps
#' @import maptools
#' @examples
#'   geo <- data.frame(long=runif(10, min=-120, max=-80), lat=runif(10, min=32, max=45))
#'   states <- latlong2map(geo, "state")
latlong2map <- function(pointsDF, mapping) {
  # Prepare SpatialPolygons object with one SpatialPolygon
  # per state (plus DC, minus HI & AK)
  local.map <- map(mapping, fill=TRUE, col="transparent", plot=FALSE)
  IDs <- sapply(strsplit(local.map$names, ":"), function(x) x[1])
  maps_sp <- map2SpatialPolygons(local.map, IDs=IDs,
                                   proj4string=CRS("+proj=longlat +datum=wgs84"))
  
  # Convert pointsDF to a SpatialPoints object 
  pointsSP <- SpatialPoints(pointsDF, 
                            proj4string=CRS("+proj=longlat +datum=wgs84"))
  
  # Use 'over' to get _indices_ of the Polygons object containing each point 
  indices <- over(pointsSP, maps_sp)
  
  # Return the state names of the Polygons object containing each point
  mapNames <- sapply(maps_sp@polygons, function(x) x@ID)
  
  mapNames[indices]
}

