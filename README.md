# Devops Metrix

Monitor useful metrics of an IT Department's projects

[Live project here](http://jrbeaudoin.github.io/devops-metrix)

# Set-up

## Requirements

* Ruby
* Capistrano
* Node + npm

## Installation

    npm install

`npm start` to see the app live served in `web/` folder.
You can then access the app at localhost:3000

# Deployment

Install capistrano

    sudo gem install capistrano

    # Deploy to the server using capistrano
    cap prod deploy
