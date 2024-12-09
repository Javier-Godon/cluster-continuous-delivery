import manifests
import .bases as bases

bases.pokedex_configmap

manifests.yaml_stream([bases.pokedex_configmap], {sep = "---"})
