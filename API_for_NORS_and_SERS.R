library(httr)
library(jsonlite)

### Step 1: Fetch all HAROs in the database
url <- "https://dvfisk.slu.se/api/V1/nors/data-aggregerad/huvudavrinningsomraden"

response <- GET(url)

response_content <- content(response, as = "text")

data <- fromJSON(response_content)

# A vector containing all the HAROs
haros <- data$haroNr

###############################
###############################
###############################

### Step 2: Extracting data from NORS

# API URL
url <- "https://dvfisk.slu.se/api/V1/nors/data-aggregerad/rapport"

## Creating the first dataframe to prepare for looping over all HAROs

# initiate the parameter with the first HARO with samples
params <- list(HaroNr = haros[2])

# Make the GET request
response <- GET(url, query = params)

NORS_extract <- fromJSON(content(response, "text"))

## Loop over all HAROs to extract data for all sampled lakes in Sweden

for(i in 3:length(haros)){
  
  # Looping over HARO
  params <- list(HaroNr = haros[i]) 
  
  # Make the GET request
  response <- GET(url, query = params)
  
  if (status_code(response) == 200) {
    # Extract content as text
    new_content <- fromJSON(content(response, "text"))
    
    # Print the content
    #print(content)
  } else {
    # Print an error message if the request failed
    print(paste("Request failed with status code:", status_code(response)))
  }
  
  if(nrow(new_content > 0)){
    NORS_extract <- rbind(NORS_extract, new_content)
  }
  
}

NORS_extract


###############################
###############################
###############################


# API URL
url <- "https://dvfisk.slu.se/api/V1/sers/data-aggregerad/rapport"

## Creating the first dataframe to prepare for looping over all HAROs

# initiate the parameter with the first HARO with samples
params <- list(HaroNr = haros[3])

# Make the GET request
response <- GET(url, query = params)

SERS_extract <- fromJSON(content(response, "text"))

## Loop over all HAROs to extract data for all electrofished sites in Sweden

for(i in 4:length(haros)){
  
  # Looping over HARO
  params <- list(HaroNr = haros[i]) 
  
  # Make the GET request
  response <- GET(url, query = params)
  
  if (status_code(response) == 200) {
    # Extract content as text
    new_content <- fromJSON(content(response, "text"))
    
    # Print the content
    #print(content)
  } else {
    # Print an error message if the request failed
    print(paste("Request failed with status code:", status_code(response)))
  }
  
    SERS_extract <- rbind(SERS_extract, new_content)

  
}

SERS_extract




