#Twistory3.0

Day by day, exactly as happened 100 years ago, World War 1  
described in real time as seen from Italy.  

##New User Setup Steps

**MySQL setup steps**  

1. Login to your MySQL server  
`mysql -u root -p`  

2. Create a database called Twistory3  
`CREATE DATABASE Twistory3;`  

3. Create a new MySQL user (note: this user is only for dev/test purposes)  
`CREATE USER 'twistory_user'@'localhost' IDENTIFIED BY 'piave1914';`  

4. Tell MySQL to grant privileges to the new user above so that it can perform operations on the Twistory3 database  
`GRANT ALL PRIVILEGES ON Twistory3.* to 'twistory_user'@'localhost';`  

5. Confirm the privileges above  
`FLUSH PRIVILEGES;`    

**Git setup steps**  

Clone the Twistory3.0 repository hosted on GitHub.  
`https://github.com/lorenzo-camaione/Twistory3.0.git`    

**Rails setup steps**  

1. Enter the base directory of the Rails app  
`cd Twistory3.0`  

2. Install required gems, as per Gemfile  
`bundle install`  

3. Run database migrations, in order to create/modify the required tables  
`rake db:migrate`  

4. Let's check if the migrations ran correctly, login with the twistory_user user created above (password: 'piave1914')  
`mysql -u twistory_user -p`  

	- Show the databases  
	`SHOW DATABASES;`  

	- Select the database  
	`USE Twistory3;`  

	- Show the tables in the Twistory3 database  
	`SHOW TABLES;`  

  If you see

  | Tables_in_Twistory3 |
  |---------------------|
  |   users             |
  |   schema_migrations |
  |   admins            |
  |   feeds             |

  then all is good    

**Running the app**    

1. On your local machine, start the Rails server  
`rails s`  

2. Launch your favorite browser, and verify that the app actually works by typing the following on your address bar  
`http://localhost:3000`  

3. (Optional) If you do not see any images, or the webpage layout looks messy, then run the following commands  
`sudo bundle exec rake assets:clean RAILS_ENV=development`  
`sudo bundle exec rake assets:clobber RAILS_ENV=development`  
`sudo bundle exec rake assets:precompile RAILS_ENV=development`    

**After creating feeds, you want to periodically push them to a specified Twitter account.**  
**Run the following task manually or, preferably, periodically in a cron job**  
`sudo bundle exec rake twitter_connection:twitter_task`    

###You're done! Enjoy history in the making :)  


