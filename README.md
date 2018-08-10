# dlaas-seedbank-spanish-to-english
0. Follow along this tutorial to set up the Watson machine learning cli, your IBM Cloud account, and a COS with training and result buckets.
1. Edit `sentences_to_translate.txt` with the spanish sentences you want to translate to English. (Sentences are separated by line breaks.)
2. Upload `sentences_to_translate.txt` to your training bucket.
3. Update `train.yaml` with the name of you training and results bucket, access key, secret access key, and endpoint.
4. ```bx ml train spa-to-eng-model.zip train.yaml```
