#common
sudo apt -y install wget unzip git cpu-checker
sudo kvm-ok

#kvm

sudo apt update
sudo apt -y install qemu qemu-kvm libvirt-bin  bridge-utils  virt-manager virt-top libguestfs-tools virtinst libvirt-daemon-system qemu-agent
sudo service libvirtd start
sudo update-rc.d libvirtd enable

#service libvirtd status
virsh version --daemon

#ansible
sudo apt update
sudo apt -y install software-properties-common
sudo apt-add-repository --yes --update ppa:ansible/ansible
sudo apt -y install ansible

#kubespray
sudo apt -y install epel-release
sudo apt -y install jinja2 --upgrade

#terraform
wget https://releases.hashicorp.com/terraform/0.12.24/terraform_0.12.24_linux_amd64.zip
sudo unzip ./terraform_0.12.24_linux_amd64.zip -d /usr/local/bin/

terraform -v

#terraform-libvirt-plugin
cd ~
terraform init
cd ~/.terraform.d
mkdir plugins
wget https://github.com/dmacvicar/terraform-provider-libvirt/releases/download/v0.6.0/terraform-provider-libvirt-0.6.0+git.1569597268.1c8597df.Ubuntu_18.04.amd64.tar.gz
tar xvf terraform-provider-libvirt-0.6.0+git.1569597268.1c8597df.Ubuntu_18.04.amd64.tar.gz
mv terraform-provider-libvirt ~/.terraform.d/plugins/

#Instal mkisofs for building the cloud-init ISO file(s) for terraform-libvirt-plugin
sudo apt install -y mkisofs 


#ssh-keygen

#create OS images directory 
#https://medium.com/@niteshvganesh/instructions-on-how-to-use-terraform-to-create-a-small-scale-cloud-infrastructure-8c14cb8603a3#41cb
sudo mkdir -p /libvirt_images/


mkdir downloads
cd downloads
wget https://cloud-images.ubuntu.com/bionic/current/bionic-server-cloudimg-amd64.img


#/etc/libvirtd/qemu.conf : security_driver = "none"
#systemctl restart libvirtd
