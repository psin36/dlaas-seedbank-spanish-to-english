# dlaas-seedbank-spanish-to-english

## Creating a [IBM][ibmcloud] Account

  1. Go to [https://console.ng.bluemix.net/](https://console.ng.bluemix.net/)
  2. Create a IBM ID if required.
  3. Log in with your IBM ID (the ID used to create your Bluemix account)

**Note:** The confirmation email from IBM Cloud mail take up to 1 hour.

## Setup your local environment to interact with IBM Cloud 

1. Open Terminal window 
2. Change to [`WML-setup-scripts/scripts/install-wml-cli/`][setup_scripts] directory
3. Run the appropraite script (`windows_wmlcli_setup.bat` or `linux-osx_wmlcli_setup.sh`) to install Bluemix CLI 
4. login to IBM Cloud using CLI
     `bx api https://api.ng.bluemix.net`
    
     `bx login`
     
      or:
     
     `bx login -sso  < select your personal account>`
5. Set resource target to default
     `bx target -g default`      
6. Running the set up scripts will install ML plugin to bx CLI, create a [Watson Machine Learning][wml_service] instance, create a [Cloud Object Store][cos_service] instance and buckets in the COS.
   ` Note: Enter a unique name for your bucket. i.e: think-<your_lastname> when asked`
   ` Note: Record the output as we will need this for the next step.`
7. Export your COS access key ID and secret access key (These are your COS credentials)

   		 export AWS_ACCESS_KEY_ID=<access_keyid_from_output_from_above>
   	     export AWS_SECRET_ACCESS_KEY=<secret_key_from_above>

8. Export ML environment variables

 	     export ML_INSTANCE=<wml_instnace id>
 	     export ML_USERNAME=<wml_instance uaerid>   
 	     export ML_PASSWORD=<wml_instnace password>
  	     export ML_ENV=<wml_instance url> 
         
## Upload data files and update the tf-train.yaml file
1. Edit `sentences_to_translate.txt` with the spanish sentences you want to translate to English. (Sentences are separated by line breaks.)

2. Upload `sentences_to_translate.txt` to Cloud Object Storage
   `aws --endpoint-url=https://s3-api.us-geo.objectstorage.softlayer.net s3 sync sentences_to_translate.txt s3://think-<your_lastname>`
 
2. Update `train.yaml` file with your COS information. Update aws_access_key_id, aws_secret_access_key and bucket names


    name: training_data_reference_name
    connection:
      endpoint_url: "https://s3-api.us-geo.objectstorage.service.networklayer.com"
      aws_access_key_id: "<access_keyid_from_above>"
      aws_secret_access_key: "<access_key_from_above>"
    source:
      bucket: think-<your_lastname>
    type: s3
    
    training_results_reference:
      name: training_results_reference_name
      connection:
        endpoint_url: "https://s3-api.us-geo.objectstorage.service.networklayer.com"
        aws_access_key_id: "<access_keyid_from_above>"
        aws_secret_access_key: "<access_key_from_above>"
      target:
        bucket: think-<your_lastname>
      type: s3

  
## Submit your training job

1. Submit the training job

 ` bx ml train spa-to-eng-model.zip train.yaml`
 
    sample output:
        Starting to train ...
        OK
        Model-ID is 'training-kHC1ACgmg' (this will be your <training_id>)

2. Monitor training run:

  `bx ml show training-runs <training_id>`

    Sample output:
          Fetching the training run details with MODEL-ID 'training-kHC1ACgmg' ...
          ModelId                  training-kHC1ACgmg
          url                      /v3/models/training-kHC1ACgmg
          Name                     tf-mnist-showtest1
          Training definition ID   64154e3a-1397-4d95-a45c-1af73421ed87
          Command                  python3 convolutional_network.py --trainImagesFile ${DATA_DIR}/train-images-idx3-ubyte.gz --trainLabelsFile ${DATA_DIR}/train-labels-idx1-ubyte.gz --testImagesFile ${DATA_DIR}/t10k-images-idx3-ubyte.gz --testLabelsFile ${DATA_DIR}/t10k-labels-idx1-ubyte.gz --learningRate 0.001 --trainingIters 20000
          Source bucket            think-sdiamond
          Target bucket            think-sdiamond
          Framework name           tensorflow
          Framework version        1.2
          State                    running
          Submitted_at             2018-03-17T19:52:00Z
          OK
          Show training-runs details successful

3. Monitor the logs of the training run:

  `bx ml monitor training-runs <training_id>`

    Sample output:
        Starting to fetch status and metrics messages for model-id 'training-kHC1ACgmg'
        [--LOGS]      Training with training/test data at:
        [--LOGS]        DATA_DIR: /mnt/data/think-sdiamond
        [--LOGS]        MODEL_DIR: /job/model-code
        [--LOGS]        TRAINING_JOB:
        [--LOGS]        TRAINING_COMMAND: python3 convolutional_network.py --trainImagesFile ${DATA_DIR}/train-images-idx3-ubyte.gz --trainLabelsFile ${DATA_DIR}/train-labels-idx1-ubyte.gz --testImagesFile ${DATA_DIR}/t10k-images-idx3-ubyte.gz --testLabelsFile ${DATA_DIR}/t10k-labels-idx1-ubyte.gz --learningRate 0.001 --trainingIters 20000
        [--LOGS]      Storing trained model at:
        ...

4.  Query training job status until status shows ‘completed’
   
   `bx ml show training-runs training-kHC1ACgmg`
   
5. You can list  the log file  or trained model or download the  trained model using the following aws cli
`aws --endpoint-url=https://s3-api.us-geo.objectstorage.softlayer.net s3 ls s3://think-<your_lastname>/<training_id>/learner-1/`

`aws --endpoint-url=https://s3-api.us-geo.objectstorage.softlayer.net s3 ls s3://think-<your_lastname>/<training_id>/model/`

# Congratulations
Yahoo!!! You completed this lab!!! :bowtie:

[ibmcloud]: https://console.ng.bluemix.net/
[wml_service]: https://console.bluemix.net/catalog/services/machine-learning?taxonomyNavigation=apps
[cos_service]: https://console.bluemix.net/catalog/services/cloud-object-storage?taxonomyNavigation=apps
[setup_scripts]: https://github.com/atinsood/WML-setup-scripts.git
