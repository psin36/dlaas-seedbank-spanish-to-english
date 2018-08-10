# dlaas-seedbank-spanish-to-english

### This lab is a shortened version of [Watson Studio Lab][watson-studio-lab]
### [Spanish-to-English model][seedbank] is taken from Google Seedbank

## Creating a [IBM][ibmcloud] Account

  1. Go to [https://console.ng.bluemix.net/](https://console.ng.bluemix.net/).
  2. Create an IBM ID if required.
  3. Log in with your IBM ID (the ID used to create your Bluemix account).

**Note:** The confirmation email from IBM Cloud mail take up to 1 hour.

## Setup your local environment to interact with IBM Cloud 

1. Download the [WML-setup-scripts][setup_scripts]. 

2. Open Terminal and move into the directory containing the scripts.  

3. Run the appropraite script (`windows_wmlcli_setup.bat` or `linux-osx_wmlcli_setup.sh`) to install Bluemix CLI. 

4. Use the IBM Cloud ID and associated password you created earlier to login when prompted.

5. The script should set your resource target to default, but if it doesn't, you can do so after the script finishes running.  
`bx target -g default`
     
6. Running the set up scripts will install ML plugin to bx CLI, create a [Watson Machine Learning][wml_service] instance, a [Cloud Object Store][cos_service] instance, and buckets in the COS.  
    ` Note: Enter a unique name for your bucket. i.e: think-<your_lastname> when asked.`   
    ` Note: Record the output as you will need this for the next step.`
    
7. Export your COS access key ID and secret access key (These are your COS credentials)

   		 export AWS_ACCESS_KEY_ID=<access_keyid_from_output_from_above>
   	     export AWS_SECRET_ACCESS_KEY=<secret_key_from_above>

   Export ML environment variables

 	     export ML_INSTANCE=<wml_instnace id>
 	     export ML_USERNAME=<wml_instance userid>   
 	     export ML_PASSWORD=<wml_instnace password>
  	     export ML_ENV=<wml_instance url> 
     
   To set these environment variables for long-term use please refer to the following:
   - [macOS][mac]
   - [linux][lin]
   - [windows][win]
     
8. Set the default output format and region for aws:

`Default region name []: us-geo`

`Default output format []: json`

## Upload data files and update the tf-train.yaml file
1. Edit `sentences_to_translate.txt` to include the Spanish sentences you want to translate to English. (Sentences are separated by line breaks.)

2. Upload `sentences_to_translate.txt` to your training bucket in the Cloud Object Storage

`aws --endpoint-url=https://s3-api.us-geo.objectstorage.softlayer.net s3 sync sentences_to_translate.txt s3://<training-bucket-name>`
 
3. Update `train.yaml` with your COS information. Update aws_access_key_id, aws_secret_access_key and bucket names.


    ```name: training_data_reference_name
    connection:
      endpoint_url: "https://s3-api.us-geo.objectstorage.service.networklayer.com"
      aws_access_key_id: "<access_keyid_from_above>"
      aws_secret_access_key: "<access_key_from_above>"
    source:
      bucket: <training-bucket-name>
    type: s3
    
    training_results_reference:
      name: training_results_reference_name
      connection:
        endpoint_url: "https://s3-api.us-geo.objectstorage.service.networklayer.com"
        aws_access_key_id: "<access_keyid_from_above>"
        aws_secret_access_key: "<access_key_from_above>"
      target:
        bucket: <result-bucket-name>
      type: s3

  
## Submit your training job
1. Create the model zip file containing the code for the model and the bash script containing the commands to be run  
  
  `zip -r spa-to-eng-model.zip nmt_with_attention.py myscript.sh`

2. Submit the training job
 
 ` bx ml train spa-to-eng-model.zip train.yaml`
 
    sample output:
        Starting to train ...
        OK
        Model-ID is 'training-kHC1ACgmg' (this will be your <training_id>)

3. Monitor training run:
  
  `bx ml show training-runs <training_id>`

    Sample output:
          Fetching the training run details with MODEL-ID 'training-kHC1ACgmg' ...
          ModelId                  training-kHC1ACgmg
          url                      /v3/models/training-kHC1ACgmg
          Name                     tf-mnist-showtest1
          Training definition ID   64154e3a-1397-4d95-a45c-1af73421ed87
          Command                  bash myscript.sh
          Source bucket            think-sdiamond
          Target bucket            think-sdiamond
          Framework name           tensorflow
          Framework version        1.2
          State                    running
          Submitted_at             2018-03-17T19:52:00Z
          OK
          Show training-runs details successful

4. Monitor the logs of the training run:
  
  `bx ml monitor training-runs <training_id>`

    Sample output:
        Starting to fetch status and metrics messages for model-id 'training-kHC1ACgmg'
        [--LOGS]      Training with training/test data at:
        [--LOGS]        DATA_DIR: /mnt/data/think-sdiamond
        [--LOGS]        MODEL_DIR: /job/model-code
        [--LOGS]        TRAINING_JOB:
        [--LOGS]        TRAINING_COMMAND: bash myscript.sh
        [--LOGS]      Storing trained model at:
        ...

5.  Query training job status until status shows ‘completed’
   
   `bx ml show training-runs training-kHC1ACgmg`
   
6. You can access the training-logs, gpu-usage, and sentence translations using the following aws cli  

gpu logs: `aws --endpoint-url=https://s3-api.us-geo.objectstorage.softlayer.net s3 ls s3://<result-bucket_name>/<training_id>/learner-1/gpulogs.csv`  

translations: `aws --endpoint-url=https://s3-api.us-geo.objectstorage.softlayer.net s3 ls s3://<result-bucket_name>/<training_id>/results.txt`

training logs: `aws --endpoint-url=https://s3-api.us-geo.objectstorage.softlayer.net s3 ls s3://<result-bucket_name>/<training_id>/learner-1/training-log.txt`

## Sample results 
Using example sentences (in `sentences_to_translate`):

Model trained with 50,000 examples: `sample_results_50000_examples_training.txt`

Model trained with 110,000 examples: `sample_results_110000_examples_training.txt`

[Google Translate][google_translate]: `sentences_translated_by_google_translate.txt`

# Congratulations
Yahoo!!! You completed this lab!!! :bowtie:

[ibmcloud]: https://console.ng.bluemix.net/
[wml_service]: https://console.bluemix.net/catalog/services/machine-learning?taxonomyNavigation=apps
[cos_service]: https://console.bluemix.net/catalog/services/cloud-object-storage?taxonomyNavigation=apps
[setup_scripts]: https://github.com/atinsood/WML-setup-scripts.git
[watson-studio-lab]: https://github.com/atinsood/watson-studio-lab.git
[seedbank]: https://tools.google.com/seedbank/seed/5695159920492544 
[mac]: https://medium.com/@himanshuagarwal1395/setting-up-environment-variables-in-macos-sierra-f5978369b255  
[win]: https://superuser.com/a/284351 
[lin]: https://askubuntu.com/a/58828
[google_translate]: https://translate.google.com/ 
