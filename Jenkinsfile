pipeline {
    agent any
    
    options {
        buildDiscarder(logRotator(numToKeepStr:'2'))
        timestamps()
    }
    
    environment {
        GIT_CRED_TOKEN = credentials('sailortoken')
        TOMCAT_HOME_DIR = '/u02/middleware/apache-tomcat-9.0.85'
        TOMCAT_BINARY_FILE ='apache-tomcat-9.0.85.tar.gz'
    }
    
    tools {
        maven '3.9.6'
        git 'git'
    }    
    
    stages {
        stage('checkout') {
            steps {
                git url: 'https://github.com/mohammadali5842/sailor.git', branch: 'main', credentialsId: 'sailortoken'
            }
        }
        stage('test') {
            steps {
               sh 'mvn test --batch-mode -Dmaven.test.failure.ignore=True' 
            }
        }
        stage('build war file') {
            steps {
                sh 'mvn clean verify'
            }
        }
        stage('install jdk') {
            steps {
                sh '''
                CHECK_JAVA=$(readlink -f $(which java))
                COUNT=$(echo $CHECK_JAVA | wc -l)
                if [ $COUNT -eq 0 ]
                then
                sudo apt update -y
                sudo apt install -y openjdk-11-jdk
                fi
                '''
            }
        }
        stage('shell') {
            steps {
                sh '''
                COUNT=$(sudo su vagrant bash -c "cat /etc/passwd | grep tomcat | wc -l")
                if [ $COUNT -eq 0 ]
                then
                sudo mkdir -p /u02/middleware
                sudo useradd -m -s /bin/bash tomcat
                sudo chown -R tomcat:tomcat /u02/
                fi
                '''
            }
        }
        stage('tomcat9 download') {
            steps {
                sh '''
                if [ ! -d "${TOMCAT_HOME_DIR}" ]
                then
                sudo su tomcat bash -c "wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.85/bin/apache-tomcat-9.0.85.tar.gz -O /u02/middleware/${TOMCAT_BINARY_FILE}"
                sudo su tomcat bash -c "tar -xvzf /u02/middleware/${TOMCAT_BINARY_FILE} -C /u02/middleware/"
                sudo su tomcat bash -c "rm -rf /u02/middleware/${TOMCAT_BINARY_FILE}"
                fi
                '''
            }
        }
        stage('cp tomcat service') {
            steps {
                sh '''
                COUNT=$(sudo su vagrant bash -c "sudo find / -type "f" -name "tomcat.service" | wc -l")
                if [ $COUNT -eq 0 ]
                then 
                sudo cp src/main/config/tomcat.service.tmp /etc/systemd/system/tomcat.service
                fi
                JAVA_HOME_FULL=$(readlink -f $(which java))
                JAVA_HOME=$(echo $JAVA_HOME_FULL | sed 's/bin.*//g')
                echo $JAVA_HOME
                sudo sed -i "s|#USER#|tomcat|g" /etc/systemd/system/tomcat.service
                sudo sed -i "s|#GROUP#|tomcat|g" /etc/systemd/system/tomcat.service
                sudo sed -i "s|#JAVA_HOME#|"${JAVA_HOME}"|g" /etc/systemd/system/tomcat.service
                sudo sed -i "s|#CATALINA_HOME#|"${TOMCAT_HOME_DIR}"|g" /etc/systemd/system/tomcat.service
                sudo systemctl daemon-reload
                sudo systemctl enable tomcat
                sudo systemctl restart tomcat
                sudo systemctl status tomcat
                
                '''
            }
        }
        stage('deploy') {
            steps {
                sh '''
                sudo cp target/sailor.war ${TOMCAT_HOME_DIR}/webapps/
                sudo systemctl restart tomcat
                '''
            }
        }
    }
}





























