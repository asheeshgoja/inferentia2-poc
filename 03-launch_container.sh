docker rm -f test_ray_mistral7b

docker run  --device=/dev/neuron0 \
           --device=/dev/neuron1 \
           --device=/dev/neuron2 \
           --device=/dev/neuron3 \
           --device=/dev/neuron4 \
           --device=/dev/neuron5 \
           --device=/dev/neuron6 \
           --device=/dev/neuron7 \
           --device=/dev/neuron8 \
           --device=/dev/neuron9 \
           --device=/dev/neuron10 \
           --device=/dev/neuron11 \
                -v /home/ubuntu:/host_files --name test_ray_mistral7b -d -p 8000:8000 -p 8265:8265 -it ray_mistral7b

docker logs test_ray_mistral7b -f