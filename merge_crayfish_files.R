




getwd()

crayfish_files <- list.files("data/crayfish", full.names = T)

read_excel(crayfish_files[1])

# Read and merge all files
crayfish_data <- lapply(crayfish_files, read_excel) %>%
  bind_rows()  # Combine all data frames

crayfish_data

names(crayfish_data)[c(9,10)] <- c("sweref99N", "sweref99E")



write.table(crayfish_data, "data/crayfish_data.csv", row.names = F, sep = ";", dec = ",")

table(crayfish_data$Metodik)
