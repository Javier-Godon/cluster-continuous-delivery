#!/bin/bash

# File containing the list of CRDs to delete
CRD_FILE="crds_to_delete.txt"

# Loop through each CRD in the file
while read -r CRD; do
  echo "Processing $CRD..."
  
  # Patch to remove finalizers
  kubectl patch crd "$CRD" -p '{"metadata":{"finalizers":[]}}' --type=merge
  
  # Delete the CRD
  kubectl delete crd "$CRD" --ignore-not-found
done < "$CRD_FILE"