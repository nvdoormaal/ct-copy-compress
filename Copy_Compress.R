#######################
## COPY AND COMPRESS ##
#######################

## 1. LOAD PACKAGES
pacman::p_load(magick, purrr, furrr)

## 2. SET MAIN FOLDER
Directory_Folder <- "./Data"  ## MAKE SURE TO INCLUDE THE FINAL FORWARD SLASH
Cameras <- list.dirs("./Data", full.names = FALSE, recursive = FALSE)

## 3. SET NEW LOCATION
New_Directory <- "./Compressed"     ## MAKE SURE TO INCLUDE THE FINAL FORWARD SLASH

## 4. LIST ALL DIRECTORIES
list.of.files <- list.files(path = "./Data", full.names = TRUE, recursive = TRUE)

## RECOMMENDED
## REMOVE THE '#' OF THE LINE BELOW IF YOU WANT TO TEST THE SCRIPT ON A SMALLER SUBSET
#list.of.files <- sample(list.of.files, 100)  ## TAKES A RANDOM SAMPLE OF 100 IMAGES 

## 5. CREATE THE MAIN MAIN FOLDER ON DESKTOP TO COPY THE FILES TO
list.of.dest.files <- gsub(Directory_Folder, New_Directory, list.of.files)

## 6. MAKE SURE EACH DIRECTORY AND SUBFOLDER IS LISTED ONCE
NewDirs <- unique(dirname(list.of.dest.files))

## 7. LOOP THROUGH THE ALL FOLDERS AND SUBFOLDERS TO CREATE THEM
for (i in 1:length(NewDirs)){
  if(!dir.exists(path = NewDirs[i])) 
    dir.create(path = NewDirs[i], recursive = TRUE)
}

## 8. FUNCTION FOR READING, RESIZING, AND WRITING IMAGES

MyFun <- function(i) {
  
  new.file.name <- gsub(Directory_Folder, New_Directory, i)
  
  magick::image_read(i) %>%  ## IMPORT PHOTOS INTO R
            image_scale("400") %>%  ## IMAGE RE-SCALING
            image_write(path = new.file.name)
  gc()
}

## 9. SET UP MULTI-CORES
no_cores <- availableCores() - 1
future::plan(multisession, workers = no_cores)

## 10. RUN FUNCTION ON ALL FILES
future_map(list.of.files, MyFun)   ## THIS MIGHT TAKE A WHILE

####################
##  SCRIPT ENDED  ##
####################

