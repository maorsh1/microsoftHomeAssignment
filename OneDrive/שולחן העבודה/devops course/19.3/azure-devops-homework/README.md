# Azure DevOps Homework Project

## Structure

- `templates/`: ARM templates for creating storage accounts and a VM.
- `pipelines/`: YAML pipeline to deploy these resources automatically via Azure DevOps.

## How to Run

Make sure you have:
- A valid Azure subscription.
- A resource group called `devops-homework`.
- Azure DevOps Service Connection set up.

Trigger the pipeline and it will deploy both storage accounts and the VM.
