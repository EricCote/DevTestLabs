# Set some variables
tenantID="790875c3-26ea-4bb0-a14f-d7f850be6fb8" # source
subID="4140bfa0-0a24-4313-a2d7-2a81d1f25dd4" # destination
sourceImageID="/subscriptions/dd670b10-b856-413d-9d91-e10a94bfc8cd/resourceGroups/Lab/providers/Microsoft.Compute/galleries/Gallery_Labs/images/WebAPI/versions/1.0.1" #source

# Login to the subscription where the new image will be created
az login

# Log in to the tenant where the source image is available
az login --tenant $tenantID

# Log back in to the subscription where the image will be created and ensure subscription context is set
az login
az account set --subscription $subID

# Create the image
az sig image-version create `
   --gallery-image-definition Blazor `
   --gallery-image-version 1.0.3 `
   --gallery-name acg_LabPlan5 `
   --resource-group RG-LAB-PLAN `
   --image-version $sourceImageID


   az sig image-version create --gallery-image-definition Blazor --gallery-image-version 1.0.4   --gallery-name acg_LabPlan5 --resource-group RG-LAB-PLAN --image-version $sourceImageID