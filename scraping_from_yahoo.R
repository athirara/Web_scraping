
# Required libraries
library(dplyr)
library(quantmod)

# List of ticker symbols
ticker_list <- c('SPY','VBMFX','TBGVX','IWM')

# Define empty dataframe
df <- data.frame()

getSymbolsYahoo <- function(ticker) { 
  
  # Data from yahoo
  data <- getSymbols(ticker, src = "yahoo", auto.assign = FALSE,from = "1900-01-01")

  # Add dates and tickers
  data <- as.data.frame(data) %>% 
    mutate(Date = index((data)), 
           ticker = ticker)

  # Rename columns
  colnames(data) <- c("Open", "High", "Low", "Close", "Volume", "Adjusted_close", "Date", "Ticker")
  
  return(data)
}

# For all tickers scrap data from yahoo
for (ticker in ticker_list) {
  df_temp <- tryCatch(getSymbolsYahoo(ticker), 
                      error = function(e) {
                        print(paste0("Could not download data for ", ticker))
                        return(data.frame())
                      })
  # Combining all data
  df <- bind_rows(df, df_temp)

}


# Save data as csv.
write.csv(df , file = "Scrapped_data.csv")
