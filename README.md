Create a HTTPS proxy to another url.
eg. point https://your-own-domain.com to https://foo.bar.com

## Prerequisites:
- know the ip `your-own-domain.com` is currently pointing to (aka the current A dns record)
- be able to change the NS dns record of `your-own-domain.com`
- aws account
- terraform installed (I have `Terraform v0.13.5` + `provider registry.terraform.io/hashicorp/aws v3.18.0` )
- terraform can access aws account


## A. Prep AWS
1.) checkout code for step `a-prep-aws`
```
git checkout a-prep-aws
```

2.) create `whatever.tfvars` file
  ```
  domain_name = "your-own-domain.com"
  region="us-east-1"
  ```
 3.) run terraform
 ```
 terraform init
 terraform apply -var-file=whatever.tfvars`
 ```

## B. (optional) Point AWS to old website
This is to keep your website up, during the time it takes for steps (C.) and (D.)
If you don't mind your previous site not working for a while,
 or if you don't have a current use for your domain yet,
 then you can feel free to skip this.

 1.) checkout code for step `b-aws-to-old-website`
 ```
 git checkout b-aws-to-old-websitee
 ```
 2.) change `whatever.tfvars` file (you can reuse the one from step (A.))
 ```
 domain_name = "your-own-domain.com"
 region="us-east-1"
 current_ip = "000.000.000.000"
 ```
 3.) run terraform
 ```
 terraform init
 terraform apply -var-file=whatever.tfvars`
 ```

## C. setup aws as DNS
Setup aws as DNS instead of old one.
If you've done step (B.) you should have the same situation as before:
 your url still points to the old website.
  But you should be going through the aws dns, instead of the previous one.

1.) get the dns NS entry

You can see this in aws console - route53 - hosted zones - `your-own-domain.com` -> Hosted zone details
```
Name servers
ns-xxx.awsdns-xx.net.
ns-xxx.awsdns-xx.org.
ns-xxx.awsdns-xx.co.uk.
ns-xxx.awsdns-xx.com.
```

2.) change the NS dns record on your domain registrar to match the one from aws

3.) wait until changes are complete
```
nslookup -type=ns your-own-domain.com
```
Can be used to check if the changes have propagated through the internet to reach you.
It should return something like this:
```
your-own-domain.com	nameserver = ns-xxx.awsdns-xx.net.
your-own-domain.com	nameserver = ns-xxx.awsdns-xx.org.
your-own-domain.com	nameserver = ns-xxx.awsdns-xx.co.uk.
your-own-domain.com	nameserver = ns-xxx.awsdns-xx.com.
```
which should be the stuff from step (1.)

This change can take a while. (like up to 48 hours or so? not sure)

## D. proxy to the new site
Here we'll proxy https://your-own-domain.com to https://foo.bar.com

1.) checkout code for step `d-proxy-to-new-site`
```
git checkout d-proxy-to-new-site
```
2.) change `whatever.tfvars` file (you can reuse the one from step (A.) and (B.))
```
domain_name = "your-own-domain.com"
region="us-east-1"
proxy_target_domain_name = "foo.bar.com"
```
3.) run terraform
```
terraform init
terraform apply -var-file=whatever.tfvars`
```
