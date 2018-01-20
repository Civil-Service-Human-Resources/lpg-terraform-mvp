# LPG Terraform

## Prerequisite

Create file key.tf add the correct values for each variable :
 
```
variable "client_id" {
  default = ""
}
variable "client_secret" {
  default = ""
}
variable "tenant_id" {
  default = ""
}
variable "subscription_id" {
  default = ""
}
``` 

## Commands

Authenticate with Azure :

``` az login ```

To install provider : 

```terraform init```

Select environment/workspace dev|test|prod to deploy to :
 
``` terraform workspace select dev ```

``` terraform plan ```

``` terrraform apply ```

Or to bypass the confirmation prompt  :

``` terrraform apply -auto-approve ```
