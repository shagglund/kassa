# Be sure to restart your server when you modify this file.

#Kassa::Application.config.session_store :cookie_store, key: '_kassa_session'

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
Kassa::Application.config.session_store :active_record_store,
                                        key: '_kassa_session',
                                        secret: '3e621469f464098407fc6a7752ec783c143e022c034419fb0208eca952653bd1eae54c'
