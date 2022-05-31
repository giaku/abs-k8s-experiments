# IMPORTANT

All deployment resources have the affinity constraints, for different clusters different names must be set. In our experiments four worker nodes were sufficient.

      affinity:
        nodeAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
            - matchExpressions:
              - key: kubernetes.io/hostname
                operator: In
                values:
                - worker--1.novalocal
                
To keep the affinity constraints change the last line of this piece of the yaml files.
