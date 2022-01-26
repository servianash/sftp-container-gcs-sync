FROM atmoz/sftp
# Install gcloudutil so we can mount GCS buckets
# Ref: https://cloud.google.com/sdk/docs/install
ENV USERNAME test
ENV BUCKETNAME bucket
ENV CRONTIME "* 1 * * *"
RUN apt-get update
RUN apt-get install -y curl gnupg wget lsb-release cron sudo
RUN apt-get install -y apt-transport-https ca-certificates gnupg
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
RUN apt-get update && apt-get install google-cloud-sdk
RUN crontab -l | { cat; echo "$CRONTIME gsutil mv /home/$USERNAME/upload gs://$BUCKETNAME"; } | crontab -
CMD cron