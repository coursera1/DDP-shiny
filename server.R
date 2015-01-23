shinyServer(function(input, output) {

        xBreaks<- reactive({
                input$breaks
        })
        
        begDate<- reactive({
                ymd(input$dateRange[1])
        })
        
        endDate<- reactive({
                ymd(input$dateRange[2])
        })
        
        data <- reactive({
                zipFileName<-input$serverZip$datapath
                if (is.null(zipFileName)) return (NULL)
                
                fileList<-unzip(zipFileName, list=TRUE)
                fileName<-sapply(strsplit(fileList$Name,"[-.]"), function(x) x[2])
                nFile<-length(fileName)
                
                d<-NULL
                for (i in 1:nFile) {
                        con <- unz(zipFileName, fileList$Name[i])
                        ## Read the data and transform into tbl_df
                        t<-tbl_df(read.csv(con, colClasses=c("character"), sep=";", header = FALSE))
                        t$name=fileName[i]
                        d<-rbind(d,t)
                }
                
                d<- d %>% mutate(time=ymd_hms(V1), sec=as.numeric(ymd_hms(V2)-ymd_hms(V1)-0.4), server=name)
                ## Trunc to nearest sec to compare
                d %>% mutate(time1=as.POSIXct(trunc(d$time, "secs"))) %>% select(time, sec, server, time1)
         })
        
        events <- reactive({
                eventFileName<-input$eventsCsv$datapath
                if(is.null(eventFileName)) return (NULL)
                d<-read.csv2(eventFileName, stringsAsFactors=FALSE) 
                d %>% mutate(time=ymd_hms(time))
        })
        
        output$G1 <- renderPlot({
                if (is.null(data())) return (NULL)
                
                ## Filter and refactor if necessary
                fData<-filter(data(), time>begDate() & time<endDate())
                if (dim(fData)[1]<1) return(NULL) ## Nothing left in filter !
                
                fData$server<-factor(fData$server)
                
                xBr<-paste(xBreaks(), "hour")
                
                ## Plot all server on same graph
                if (is.null(events())) {
                        qplot(time, sec, data=fData, col=server, geom="point", alpha=0.7, size=sec, 
                              main="Values for all servers", xlab="Time", ylab="Values (s)") +
                                scale_x_datetime( breaks=xBr, labels = date_format("%d/%m %Hh")) +
                                geom_hline(yintercept=1) +
                                theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
                                coord_cartesian(ylim = c(0, input$yLimit)) +
                                theme(legend.position = "none")
                } else {
                        fEvents<-filter(events(), time>begDate() & time<endDate())

                        qplot(time, sec, data=fData, col=server, geom="point", alpha=0.7, size=sec, 
                              main="Values for all servers", xlab="Time", ylab="Value (s)") +
                                scale_x_datetime( breaks=xBr, labels = date_format("%d/%m %Hh")) +
                                geom_hline(yintercept=1) +
                                geom_vline(xintercept=as.numeric(fEvents$time)) +
                                theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
                                coord_cartesian(ylim = c(0, input$yLimit)) +
                                theme(legend.position = "none")
                }
        })
        
        output$serverValue<- renderDataTable({
                if (is.null(data())) return (NULL)
                
                fData<-filter(data(), time>begDate() & time<endDate())
                fData$server<-factor(fData$server)
                
                fData %>% arrange(desc(sec)) %>% select(time, sec, server)
        })
        
        output$tEvents <- renderDataTable({
                if (is.null(events())) return (NULL)
                
                fEvents<-filter(events(), time>begDate() & time<endDate())
                
                fEvents
        })
        
})