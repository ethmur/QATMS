QA TicketManagementSystem

This software project allows for the basic management of tickets.

JIRA board link: https://ethanbarcims.atlassian.net/browse/TMS

Components:
	- Database (MySQL)
	- Backend (Spring Boot)
	- Frontend (ReactJS)
	- Gateway Reverse Proxy (Spring Boot)
	
Software dependencies
	- MySQL
	- Java 8
	- Maven
	- nodeJS/npm
	- Selenium Webdriver
	- (Optional) Eclipse
	- (Optional) Visual Studio Code
	
Local Environment Setup
	- Database (MySQL)
		1) Install MySQL
		2) Create MySQL instance with following properties (if you change these properties, you will need to modify the backend application.properties config file accordingly):
			Port: 3306
			Username: root
			Password: password
		3) Execute SQL script at db/ticket.sql to initialize the database and tables
	- Backend (Spring Boot)
		1) Install Java 8, Maven
		2) (Optional) Import the backend project into Eclipse.
		3) To install maven dependencies: run command mvn clean package
		4) To start the backend server: run main class backend/src/main/java/tms_backend/tms_backend/TmsBackendApplication.java
		5) To run unit & integration tests: run command mvn test
	- Frontend (ReactJS)
		1) Install nodeJS/npm, Selenium Webdriver
		2) (Optional) Import the ui project into Visual Studio Code
		3) To install node module dependencies: run command npm install
		4) To start the UI: run command npm run start
		5) To run selenium UI tests: run command node ui/tests/seleniumtests.js
	- Gateway Reverse Proxy (Spring Boot)
		1) Install Java 8, Maven
		2) (Optional) Import the gateway project into Eclipse.
		3) To install maven dependencies: run command mvn clean package
		4) To start the backend server: run main class gateway/src/main/java/tms_gateway/tms_gateway/TmsGatewayApplication.java
		
Interacting with the UI
	- UI link (through gateway reverse proxy): http://localhost:8081/tms/ui
	- Using the UI, you can do the following:
		- View all tickets
		- Create ticket
		- Update ticket
		- Delete ticket
	- UI supports the following ticket properties:
		- Title
		- Description
		- Author
		- Status
		- Time Created