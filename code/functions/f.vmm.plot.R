f.vmm.plot<-function(var,unit,start,stop){
  vmm.waterstand<-get_stations(var)
  vmm.waterstand <- get_timeseries_tsid(vmm.waterstand$ts_id[which(vmm.waterstand$station_id=="12122")],from = start,to = stop)
  return(ggplot(vmm.waterstand, aes(x = Timestamp, y = Value)) + 
    geom_line() + 
    xlab("") + ylab("m") + 
    scale_x_datetime(date_labels = "%H:%M\n%Y-%m-%d", date_breaks = "1 year") + theme_bw() + theme(text = element_text(size = 12, family = "serif"), axis.text.x = element_text(hjust = 0.5, vjust = 0.5, family = "serif"), strip.background = element_rect(colour = "black", fill = "white"), legend.position = "bottom"))  + xlab("datum") + ylab(paste0(var," (",unit,")"))
}

f.vmm.plot.series<-function(var,unit,data){
  for (i in 1:nrow(data)){
    vmm.waterstand.temp<-get_stations(var)
    vmm.waterstand.temp <- get_timeseries_tsid(vmm.waterstand.temp$ts_id[which(vmm.waterstand.temp$station_id=="12122")],from = as.Date(data$min.date[i]),to = as.Date(data$max.date[i]))
    vmm.waterstand.temp$sectie=data$sectie[i]
    vmm.waterstand.temp$jaar=data$jaar[i]
    if (i==1){
      vmm.waterstand=vmm.waterstand.temp
    } else {
      vmm.waterstand=rbind(vmm.waterstand,vmm.waterstand.temp)
    }
  }
  return(ggplot(vmm.waterstand, aes(x = Timestamp, y = Value)) + 
    geom_line() + 
    scale_x_datetime(date_labels = "%H:%M\n%Y-%m-%d", date_breaks = "1 day") + theme_bw() + theme(text = element_text(size = 12, family = "serif"), axis.text.x = element_blank(), strip.background = element_rect(colour = "black", fill = "white"), legend.position = "bottom") + facet_wrap(~sectie*jaar,scales="free_x")) + xlab("datum") + ylab(paste0(var," (",unit,")"))
}