#!/bin/bash
# 20190912
# single-node
# run as root

# paste instructions for nginx ingress controller here

###################
# Helm Installation
###################

## Linux installation
wget https://storage.googleapis.com/kubernetes-helm/helm-v2.14.1-linux-amd64.tar.gz && tar xfv helm-v2.14.1-linux-amd64.tar.gz && sudo mv linux-amd64/helm /usr/local/bin && rm -rf linux-amd64/ && rm helm-v2.14.1-linux-amd64.tar.gz
## OS X installation
wget https://storage.googleapis.com/kubernetes-helm/helm-v2.14.1-darwin-amd64.tar.gz && tar xfv helm-v2.14.1-darwin-amd64.tar.gz && sudo mv darwin-amd64/helm /usr/local/bin && rm -rf darwin-amd64/ && rm helm-v2.14.1-linux-amd64.tar.gz

## First steps with Helm
helm init
helm search stable
helm install --name dokuwiki stable/dokuwiki
helm list

## Create a new chart skeleton
my-wordpress/nginx
## Let's use the solution we made to create a WP chart
mv my-nginx/ my-wordpress/
rm -rf my-wordpress/templates/*
cp -rf ../intel-training-1/activity/solution/*.yaml my-wordpress/templates/
kubectl create namespace intel
helm install --name my-wordpress my-wordpress/

## Deploy WordPress modifying some settings
helm install --name my-wordpress my-wordpress --set app.blogname="This is my blog"

## Install Official Stable WP and Upgrades
helm install stable/wordpress --name my-stable-wordpress
helm upgrade my-stable-wordpress stable/wordpress --set ingress.enabled=true
helm upgrade my-stable-wordpress stable/wordpress --set image.tag=5.2.1
helm history my-stable-wordpress

## Chart repositories
helm repo list
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
