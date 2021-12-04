pipeline{
    agent any
    tools {
        jdk 'Java_Home'
        maven 'Maven_Home' 
    }
    triggers {
        cron 'H H * * *'
   }
    options {
        buildDiscarder logRotator(daysToKeepStr: '9', numToKeepStr: '7')
        timeout(time: 1, unit: 'HOURS') 
    }
    environment{
        tomcatweb = "/var/lib/tomcat/webapps/"
        registry = "sanjana141996/myapp"
        registryCredential = 'dockercred'
        dockerImage = ''
    }
    parameters{
        booleanParam(name: 'DEPLOY', defaultValue: true, description: 'make it TRUE if you want to deploy')
        gitParameter(branch: '', branchFilter: '.*', defaultValue: 'master', description: 'enter the branch name', name: 'branch', quickFilterEnabled: false, selectedValue: 'NONE', sortMode: 'NONE', tagFilter: '*', type: 'PT_BRANCH')
    }
stages{
    stage('checkout'){
        steps{
            checkout([
                $class: 'GitSCM', 
                branches: [[name: "${params.branch}"]], 
                extensions: [], 
                userRemoteConfigs: [[url: 'https://github.com/sanjaprakash/webapplication.git']]
            ])
        }
    }
    stage("Cobertura Build"){
        steps{
            echo " This is a Tesing Demo from Visual Studio for testing purpose"
            sh"""
                mvn clean cobertura:cobertura -Dcobertura.report.formats=xml
            """
        }
		
    }
    stage("cobertura publish"){
        steps{
            cobertura autoUpdateHealth: false, 
            autoUpdateStability: false, 
            coberturaReportFile: '**/target/site/cobertura/coverage.xml', 
            conditionalCoverageTargets: '70, 60, 40', 
            lineCoverageTargets: '80, 70, 60', 
            maxNumberOfBuilds: 0, 
            methodCoverageTargets: '80, 60, 40', 
            onlyStable: false, 
            packageCoverageTargets: '80, 60, 40', 
            sourceEncoding: 'ASCII', 
            zoomCoverageChart: false
        }
		}
    stage('SonarQube Analysis') {
        steps{
          withSonarQubeEnv('Sonar') { 
          sh "mvn sonar:sonar"
        }
    }
	}
    stage("build"){
        steps{
            echo "building"
            sh """
             mvn clean install
             """
        }
    }
    stage("Docker_Build"){
	    steps{
	        script{
	            dockerImage = docker.build registry + ":$BUILD_NUMBER"
	    }
	    }
	}
    stage("Docker_Push_Image"){
	    steps{
	        script{
	            docker.withRegistry( '', registryCredential ) {
                dockerImage.push()
	    }
	    }
	}
	}
    stage("deploy"){
        when {
                // Only say hello if a "greeting" is requested
                expression { params.DEPLOY }
            }
        steps{
              sh "cp target/java-tomcat-maven-example.war ${tomcatweb}"
}
}
}
post{
    always{
        cleanWs()
    }
}
}
