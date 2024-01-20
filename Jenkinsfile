@Library('sharedlibrary')_

pipeline {
    environment {
        ecrAccount = "227219889473.dkr.ecr.ap-southeast-1.amazonaws.com"
        awsRegion = "ap-southeast-1"
        awsKeys = "awsCred"
        eksClusterName = "eks-cluster"
        gitHubCredential = "githubCred"
                
        gitRepoURL = "${env.GIT_URL}"
        gitBranchName = "${env.BRANCH_NAME}"
        repoName = sh(script: "basename -s .git ${GIT_URL}", returnStdout: true).trim()
        dockerImage = "${ecrAccount}/${repoName}"
        branchName = sh(script: 'echo $BRANCH_NAME | sed "s#/#-#"', returnStdout: true).trim()
        gitCommit = "${GIT_COMMIT[0..6]}"
        dockerTag = "${branchName}-${gitCommit}"
    }
    
    agent {label 'docker'}
    stages {
        stage('Git Checkout') {
            steps {
                gitCheckout("$gitRepoURL", "refs/heads/$gitBranchName", '$gitHubCredential')
            }
        }

        stage('Docker Build') {
            steps {
                dockerImageBuild('$dockerImage', '$dockerTag')
            }
        }

        stage('Docker Push') {
            steps {
                dockerECRImagePush('$dockerImage', '$dockerTag', '$repoName', '$awsKeys', '$awsRegion')
            }
        }

        stage('Kubernetes Deploy - DEV') {
            when {
                anyOf {
                    branch 'development'
                }
            }
            steps {
                kubernetesHelmDeployEnv('$dockerImage', '$dockerTag', '$repoName', '$awsKeys', '$awsRegion', '$eksClusterName', 'dev')
            }
        }

        stage('Kubernetes Deploy - UAT') {        
            when {
                branch 'master_staging'
            }
            steps {
                kubernetesHelmDeployEnv('$dockerImage', '$dockerTag', '$repoName', '$awsKeys', '$awsRegion', '$eksClusterName', 'uat')
            }
        }

        stage('Kubernetes Deploy - PROD') {
            when {
                branch 'master'
            }
            steps {
                kubernetesHelmDeployEnv('$dockerImage', '$dockerTag', '$repoName', '$awsKeys', '$awsRegion', '$eksClusterName', 'prod')
            }
        }

    }
}