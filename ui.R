shinyUI(fluidPage(
        titlePanel("Interactive Server Graph"),
        h5("Please, read Help section to get started"),
        
        sidebarLayout(
                sidebarPanel(
                        h3("Input"),
                        fileInput("serverZip", "Upload servers Zip file", multiple=FALSE, accept="application/zip"),
                        fileInput("eventsCsv", "Upload events csv file", multiple=FALSE, accept="text/csv"),
                        h3("Graph Tuning"),
                        dateRangeInput("dateRange", "Select date range for graphs", start="2014-11-01"),
                        sliderInput("breaks", "X axis ticks", 0, 48, 6, 3, round=TRUE),
                        sliderInput("yLimit", "Y axis limit", 0, 10, 4, 1, round=TRUE),
                        h3("Help"),
                        h5("Introduction"),
                        h6("This application is used to analyze the results of a monitoring script that runs 
                           on different servers in a datacenter. Please, follow the instructions below to run this app."),
                        h5("Upload zip file"),
                        h6("The script generate a log file on each server. 
                           They are then combined in a zip file. It is this zip file that needs to be loaded in the 'Upload server zip file'.
                           This action will generate the graph in the main panel. You can download an example of the zip file in the 
                           githup repository associated with this project (right click on the link -> save link ...): ", a("Input.zip",href="http://github.com/coursera1/DDP-Project/raw/master/Input.zip")),
                        h6("Now, just clic the 'Choose file' and select the 'Input.zip' file you've just downloaded."),
                        h6("Once this done, you can play around with the graph tuning parameters to select the date range, the x axis tick or the y axis limit and see the results on the graph."),
                        h5("Graph"),
                        h6("The monitored values are plotted on the Y axis and colored by server names. The size of the dots were made proportional to the values to make them more 
                           visible as these points are more important for the analysis."),
                        h5("Upload events file"),
                        h6("You can optionally upload another file that contains a series of time-events associations that will be plotted
                           as vertical lines on the graph. You can find an example here (right click on the link -> save link  ...): ", a("Events.cvs",href="http://github.com/coursera1/DDP-Project/raw/master/Events.csv")),
                        h5("Table views"),
                        h6("Two table views of the servers values and time-events data are displayed under the graph.")),
                mainPanel(h3("Graph"),
                          plotOutput("G1"),
                          h3("Server Values"),
                          dataTableOutput("serverValue"),
                          h3("Events"),
                          dataTableOutput("tEvents")
                )
        )
))