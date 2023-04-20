#install docker https://github.com/kubernetes/minikube/issues/10494

#install kubeadm
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl
sudo curl -fsSLo /etc/apt/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl

sudo apt-mark hold kubelet kubeadm kubectl
#install cri socket

#install containerd https://forum.linuxfoundation.org/discussion/862825/kubeadm-init-error-cri-v1-runtime-api-is-not-implemented
apt update
systemctl stop docker
apt remove containerd.io -y
apt install containerd.io docker-ce docker-ce-cli -y
rm /etc/containerd/config.toml
systemctl restart containerd
#apt install docker-ce docker-ce-cli -y

#mb helps: netstat
#apt install net-tools
#sudo netstat -tulpn | grep '10259\|10257\|2379\|2380'

kubeadm init
export KUBECONFIG=/etc/kubernetes/admin.conf

#какойто канал
curl https://raw.githubusercontent.com/projectcalico/calico/v3.25.1/manifests/canal.yaml -O
kubectl apply -f canal.yaml

#чтобы работало
sudo -i
swapoff -a
exit
strace -eopenat kubectl version