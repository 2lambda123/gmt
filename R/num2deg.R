num2deg <- function(x, lat=NA, dec=FALSE, digits=0, zero=FALSE)
{
  if (length(x) > 1)  # recursion allows element-specific format
  {
    mapply(num2deg, x, lat=lat, dec=dec, digits=digits, zero=zero)
  }
  else
  {
    if(is.na(x))
      return(NA_character_)

    ## 1  Determine degrees, minutes, and seconds
    sign <- sign(x)
    x <- abs(x)  # work with absolute x, remember sign
    d <- trunc(x)
    m <- trunc(60 * (x-d))
    s <- round(3600*(x-d-m/60), digits=digits)
    if(s == 60)
    {
      s <- 0
      m <- m + 1
    }
    if(m == 60)
    {
      m <- 0
      d <- d + 1
    }
    m <- if(m < 10) paste0("0", m) else m
    s <- if(s < 10) paste0("0", s) else s
    if(dec)
      dms <- round(x, digits)
    else
      dms <- paste(d, m, s, sep=":")

    ## 2  Format details
    if(!zero)
      ## Remove trailing :00, first sec, then min
      dms <- gsub(":00$", "", gsub(":00$","",dms))
    if(is.na(lat))  # hemisphere not available, prepend minus if negative value
    {
      minus <- if(sign < 0) "-" else ""
      deg <- paste0(minus, dms)
    }
    else  # hemisphere known, append N|S|E|W
    {
      hemi <- if(lat && sign>=0) "N"
              else if(lat && sign<0) "S" else if(!lat && sign>=0) "E" else "W"
      deg <- paste0(dms, hemi)
    }

    deg
  }
}
