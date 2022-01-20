# README

This README would normally document whatever steps are necessary to get the
application up and running.

Step 1:

* Download and install docker from https://www.docker.com/products/docker-desktop


Step 2 :

* Open the terminal
* Move to the path you want to set the project on it
* Write     git clone https://github.com/fodaamr8/chat_test.git


Step 3 :
* Move to the project path by cd {{PATH_OF_PROJECT}}        // PATH_OF_PROJECT  the folder that you made git clone on it
* Write docker-compose up

After finish (docker-compose up) you will have 6 containers running

* Mysql database container   // PORT : 3307
* Elasticsearch container   // PORT : 9200
* Kibana container   //  PORT : 5601 , i use this to monitor the elasticsearch and indexes
* Sidekiq container     //  to handle the queue approche on peoject
* Redis container   //  PORT : 5601 , Sidekiq is one of the more widely used background job frameworks that you can implement in a Rails application. It is backed by Redis , Redis as a job management store to process thousands of jobs per second
* Chat_test container    // PORT : 3001 , to run whole app


Note : 
- the postman documentation is json file in the project  named : ( chat_test.postman_collection.json )

