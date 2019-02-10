surveys_plot +
    geom_line() + 
    theme(axis.text.x = element_text(size = 15, ang=90, color = "purple"), 
          axis.text.y = element_text(size = 2, color = "red"), 
          axis.title.y = element_text(size = 20), 
          plot.background = element_rect(fill="green"), 
          panel.background = element_rect(fill="red", color="black"), 
          panel.grid.major = element_line(colour = "red"), 
          panel.grid.minor = element_line(colour = "purple"), 
          title = element_text(size = 1), 
          #        axis.line.x = element_line(colour = "black"), 
          #        axis.line.y = element_line(colour = "black"), 
          strip.background = element_rect(fill = "orange", color = "black"), 
          strip.text = element_text(size = 15, color="red"),
          legend.background = element_rect(fill="black"),
          legend.text = element_text(color="gray"),
          legend.key=element_rect(fill="white"))
