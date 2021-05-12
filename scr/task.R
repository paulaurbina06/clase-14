#===========================================================================#
# Autor(es): Eduard Martinez
# Colaboradores: 
# Fecha creacion: 12/05/2021
# Fecha modificacion: 12/05/2021
# Version de R: 4.0.3.
#==============================================================================#

# intial configuration
rm(list = ls()) # limpia el entorno de R
require(pacman)
p_load(tidyverse,data.table,plyr,XML,rvest,xml2) # cargar y/o instalar paquetes a usar

# carguemos una lista de URL
load("data/input/REPEC.Rdata")
View(datos)

# Como se ve la pagina
datos[1,3] %>% as.character()
browseURL(url = datos[1,3] %>% as.character())

# conviratmos en html y descarguemos las tablas
myhtml = datos[1,3] %>% as.character() %>% read_html()
myhtml %>% htmlParse() %>% readHTMLTable(header = T)

# dejemos unicamente la segunda tabla
tabla = myhtml %>% htmlParse() %>% readHTMLTable(header = T) %>% .[[2]]

# creemos una lista con los ID de cada documento
id_repec = datos[,"identif_REPEC"] %>% unlist() %>% as.character()
id_repec

# construyamos la funcion
fun_REPEC = function(x){
  if(is.na(x) == F){ 
    url = as.character((datos[which(id_repec == x),"estadisticas"]))
    if(url != "") {
      url_html = url %>% read_html()
      res = url_html %>% htmlParse() %>% readHTMLTable(header = T) %>% .[[2]]
      res$id_repec = x
      res$titulo = url_html %>% html_node('.gptitle') %>% html_text()
      return(res)
    }
  }
} 

# aplicando funcion
estadisticas = lapply(id_repec[1:5], fun_REPEC)
estadisticas = do.call(rbind, estadisticas)
