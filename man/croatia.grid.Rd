\name{croatia.grid}
\alias{croatia.grid}
\docType{data}
\title{
SpatialPointsDataFrame of a 24980 pixel grid in Croatia, with static topographic
predictors such as: spatial coordinates, DEM, DSEA and TWI information.
}
\description{
  A SpatialPointsDataFrame with 24980 observations on the following variables:
  \describe{
    \item{\code{x}}{a numeric vector; x-coordinate; Spatial reference system: UTM 33N}
    \item{\code{y}}{a numeric vector; y-coordinate; Spatial reference system: UTM 33N}
    \item{\code{HRdem}}{a numeric vector, Digital Elevation Model (DEM, in meters)}
    \item{\code{HRdsea}}{a numeric vector with topographically weighted distances from the coast line (DSEA, in km)}
    \item{\code{HRtwi}}{a numeric vector with topographic wetness index}
}
}
\usage{data(croatia.grid)}

\references{
Hengl, T. (2009). \emph{A Practical Guide to Geostatistical Mapping}, 2nd edn, University of Amsterdam, Amsterdam.

Hengl, T., Heuvelink Gerard, B. M., Percec Tadic, M. & Pebesma, E. J. (2012).
\emph{Spatio-temporal prediction of daily temperatures using time-series of
MODIS LST images}, Theoretical and Applied Climatology 107, 1-2, 265-277.

Melo, C. E. (2012). \emph{Analisis geoestadistico espacio tiempo basado en distancias y splines con
aplicaciones}. PhD. Thesis. Universitat de Barcelona. 276 p.
\href{http://www.tdx.cat/bitstream/handle/10803/101202/CEMM_TESIS.pdf}{[link]}
}
\seealso{
\code{\link{croatia.temp}}
}

\examples{
data(croatia.grid)
plot(croatia.grid@coords)

\dontrun{
data(croatia2008)
coordinates(croatia2008)<-~x+y

GridsT <- vector(mode = "list", length = 12)
for(i in 1:12){
GridsT[[i]] <- data.frame(croatia.grid@coords,croatia.grid@data,i)
names(GridsT[[i]]) <- c("x","y","dem","dsea","twi","t")
}
rbf.croatia1 <- data.frame(matrix(NA, ncol = 14, nrow=nrow(GridsT[[1]])))
pb <- txtProgressBar(min = 0, max = 12, char = "=", style = 3)
for(i in 1:12){
coordinates(GridsT[[i]]) <- c("x", "y")
rbf.croatia1[,i+2] <- rbfST(MTEMP~x+y+dem+dsea+twi+t, data=croatia2008, eta=0.3368421,
                      rho=0.02105263, n.neigh=40, func="TPS", newdata=GridsT[[i]],
                      progress=FALSE)[,4]
setTxtProgressBar(pb, i)
}
close(pb)

rbf.croatia1[,1:2] <- GridsT[[1]]@coords
nam <- paste(c("JAN","FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OCT","NOV","DEC"),2008,sep="")
names(rbf.croatia1) <- c("x","y",nam)

coordinates(rbf.croatia1) <- c("x", "y")
gridded(rbf.croatia1) <- TRUE

# show prediction map
pal2 <- colorRampPalette(c("blue3", "wheat1", "red3"))

p1 <- spplot(rbf.croatia1[,c(10,11,12,7,8,9,4,5,6,1,2,3)], cuts=30,
      par.strip.text = list(style = 1, cex = 0.7), col.regions=pal2(35),
      colorkey=F, scales = list(draw =T, cex=0.6, abbreviate=TRUE,minlength=1),
      pch=0.3, cex.lab=0.3, cex.title=0.3, auto.key = F, main = "",
      key.space=list(space="right", cex=0.8))

#par(mar=c(0,0,0,5))
split.screen( rbind(c(0, 1,0,1), c(1,1,0,1)))
split.screen(c(1,2), screen=1)-> ind
screen( ind[1])

p1
screen( ind[2])
image.plot(legend.only=TRUE, legend.width=0.5, col=pal2(100),
           smallplot=c(0.7,0.75, 0.3,0.7), zlim=c(min(rbf.croatia1@data),
           max(rbf.croatia1@data)), axis.args = list(cex.axis = 0.6))
close.screen( all=TRUE)
}
}

\keyword{datasets}
