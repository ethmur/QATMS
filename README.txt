QA TicketManagementSystem
Author: Ethan Murad


JIRA board link: https://ethanbarcims.atlassian.net/browse/TMS
JIRA invite link: https://id.atlassian.com/invite/p/jira-software?id=Rvolh4s8TiOafJ8wBd_lGw


Application:
	- This application allows for the basic management of tickets
	- The following actions are supported: 
		- Create
		- Read
		- Update
		- Delete
	- The following ticket properties are supported:
		- Title
		- Description
		- Author
		- Status
		- Time Created
	- Components:
		- Database (MySQL)
		- Backend (Spring Boot)
		- Frontend (ReactJS)
		- Gateway Reverse Proxy (Spring Boot)
	
	
Deployment:
	- Application is deployed onto AWS using a CI/CD pipeline
	- Tools/services used
		- git + GitHub
		- terraform
		- ansible
		- jenkins
		- docker + DockerHub
		- kubernetes
		- AWS
			- VPC
			- EC2
			- EKS
			- RDS
	- Deployment steps:
		1) Create an EC2 machine (ubuntu recommended) which will be used to deploy the application and infrastructure
		2) SSH to the EC2 machine
		On the EC2 machine:
			3) Clone the repository
				git clone https://github.com/ethmur/QATMS
			4) Run shell script to install required dependencies on EC2 machine (note: this script only supports ubuntu)
				./QATMS/ci/scripts/install_dependencies.sh
			5) Configure AWS CLI credentials
				aws configure
			6) Run shell script to deploy & configure TicketManagementSystem infrastructure into AWS
				./QATMS/ci/scripts/deploy.sh
			7) Connect to Jenkins UI in browser
		On the Jenkins UI:
			8) Configure DockerHub credentials
			9) Manually trigger following Jenkins jobs:
				- backend
				- frontend
				- gateway
		On GitHub:
			10) Setup GitHub webhook to trigger Jenkins jobs automatically
	- How to determine TicketManagementSystem UI URL:
		- Retrieve load balancer public hostname from AWS console (there should be exactly 1 load balancer)
		- TicketManagementSystem URL is http://[LOAD_BALANCER_URL]/tms/ui/        (important: the trailing forward slash is required)
			

Repository folder structure:
	- backend/ folder
		- source code for Spring Boot backend
		- source code for backend tests (using, JUnit, H2, Mockito)
		- backend deployment descriptor files
	- ui/ folder
		- source code for nodeJS UI
		- source code for UI tests (using selenium)
		- UI deployment descriptor files
	- gateway/ folder
		- source code for Spring Boot gateway reverse proxy service
		- gateway deployment descriptor files
	- db/ folder
		- SQL script to initialize the MySQL database
	- ci/ folder
		- source code for CI/CD pipeline
		- terraform IaC resources
		- ansible playbook & inventory files
		- utilitary shell scripts
	- docs/ folder
		- supplementary documentation/diagrams/videos to go with the project
		- ER diagram
