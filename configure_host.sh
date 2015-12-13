echo "download and install terraform and custom provider"
curl https://releases.hashicorp.com/terraform/0.6.8/terraform_0.6.8_linux_amd64.zip -o ~/terraform.zip
unzip ~/terraform.zip -d /usr/local/bin/
curl https://s3-us-west-1.amazonaws.com/22acacia-deploy/custom-binaries/terraform-provider-googlecli -o /usr/local/bin/terraform-provider-googlecli
chmod +x /usr/local/bin/terraform-provider-googlecli

echo "ensure kubectl is installed and that dataflow commands for gcloud are installed"
which kubectl
if [ $? -eq 1 ]; then
  /opt/google-cloud-sdk/bin/gcloud components install kubectl -q
fi
/opt/google-cloud-sdk/bin/gcloud alpha -h < /bin/echo
/opt/google-cloud-sdk/bin/gcloud beta -h < /bin/echo
chown ubuntu:ubuntu -R ~/.config/

