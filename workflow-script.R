library(workflowr)
wflow_git_config(user.name = "Apoorv Anand", user.email = "apoorv7491@gmail.com")
wflow_start(directory = ".", existing = TRUE)
wflow_build()
wflow_status()
wflow_publish(files = "analysis/*.Rmd",message = "Commit initial workflow files")
