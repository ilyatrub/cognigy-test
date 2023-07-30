variable "region" {
  description = "AWS region"
  type = string
  default = "eu-central-1"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type = string
  default = "10.0.0.0/16"
}

variable "az_count" {
  description = "Number of AZ in regions"
  type = number
  default = 2
}

variable "subnet_cidr_bits" {
  description = "Number of additional subnet CIDR bits"
  type = number
  default = 8
}

variable "eks_cluster_name" {
  description = "Name of EKS cluster"
  type = string
  default = "test-eks-cluster"
}

variable "kubernetes_version" {
  description = "Desired Kubernetes version"
  type = string
  default = "1.24"
}

variable "node_group_min_size" {
  description = "Min number of nodes for EKS cluster"
  type = number
  default = 1
}

variable "node_group_max_size" {
  description = "Max number of nodes for EKS cluster"
  type = number
  default = 3
}

variable "node_group_desired_size" {
  description = "Desired number of nodes for EKS cluster"
  type = number
  default = 2
}

variable "node_instance_types" {
  description = "List of instance types to use for EKS nodes"
  type = list(string)
  default = [ "t2.micro" ]
}