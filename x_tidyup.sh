# Cleanup from previous demo runs
pkill kubectl
helm ls --all --short | xargs -L1 helm delete --purge
