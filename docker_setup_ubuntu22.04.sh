## Update + Upgrade
sudo apt update && sudo apt upgrade -y

## Benötigte Pakete installieren
sudo apt install apt-transport-https ca-certificates curl software-properties-common

## GPG-Key hinzufügen
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

## Docker Repository zu APT-Sources hinzufügen
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

## Erneut updaten
sudo apt update 

## Sichergehen vom Docker Repo zu installieren
apt-cache policy docker-ce

## Docker installieren
sudo apt install docker-ce

## User auf Docker berechtigen
sudo usermod -aG docker ${USER}
