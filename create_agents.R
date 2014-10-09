polling <- import_polling()
agents <- to_voters(voters, 1000)
agents <- dplyr::left_join(agents, polling)
