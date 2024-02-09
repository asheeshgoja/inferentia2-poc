# Use a base image with the desired Linux distribution
FROM ubuntu:jammy

RUN . /etc/os-release
RUN echo "deb https://apt.repos.neuron.amazonaws.com jammy main" > /etc/apt/sources.list.d/neuron.list

RUN apt-get update -y
RUN apt-get install wget -y
RUN apt-get install -y  gnupg
RUN wget -qO - https://apt.repos.neuron.amazonaws.com/GPG-PUB-KEY-AMAZON-AWS-NEURON.PUB | apt-key add -
RUN apt-get update -y
RUN apt-get install linux-headers-$(uname -r) -y
RUN apt-get install git -y

# Install Neuron Runtime 
RUN apt-get install aws-neuronx-collectives=2.* -y
RUN apt-get install aws-neuronx-runtime-lib=2.* -y

# Install Neuron Tools
RUN apt-get install aws-neuronx-tools=2.* -y
ENV PATH="/opt/aws/neuron/bin:$PATH"

# Install venv
RUN apt-get install -y python3.10-venv g++ 

# Install pip
RUN apt-get update && apt-get install -y python3-pip


# Create Python venv
RUN python3.10 -m venv aws_neuron_venv_pytorch
ENV VIRTUAL_ENV /aws_neuron_venv_pytorch
ENV PATH /aws_neuron_venv_pytorch/bin:$PATH
RUN pip install --upgrade pip

# Install Jupyter notebook kernel
RUN pip install ipykernel 
RUN python3.10 -m ipykernel install --user --name aws_neuron_venv_pytorch --display-name "Python (torch-neuronx)"
RUN pip install jupyter notebook
RUN pip install environment_kernels

# Set pip repository pointing to the Neuron repository 
RUN pip config set global.extra-index-url https://pip.repos.neuron.amazonaws.com

# Install wget, awscli 
RUN pip install wget 
RUN pip install awscli 

# Install Neuron Compiler and Framework
RUN pip install neuronx-cc==2.* --pre torch-neuronx==2.1.* torchvision




# transformers_neuronx
RUN pip install transformers-neuronx --extra-index-url=https://pip.repos.neuron.amazonaws.com

# install ray
RUN pip uninstall starlette
RUN pip install "ray[serve]"
RUN pip install starlette==0.34.0
# RUN pip install optimum[neuronx]


# COPY mistral-7b-ray-hosted.py .
# COPY Llama-2-13b-chat-hf-neuron-throughput-ray-hosted.py .
COPY mistral-7b-ray-streaming.py .

COPY run.sh .

EXPOSE 8000
EXPOSE 8265

# launch ray app
CMD ["bash", "run.sh"]/














# # Use a base image with the desired Linux distribution
# FROM ubuntu:jammy
# # FROM ubuntu:focal

# RUN . /etc/os-release
# RUN echo "deb https://apt.repos.neuron.amazonaws.com jammy main" > /etc/apt/sources.list.d/neuron.list

# RUN apt-get update -y
# RUN apt-get install wget -y
# RUN apt-get install -y  gnupg
# RUN wget -qO - https://apt.repos.neuron.amazonaws.com/GPG-PUB-KEY-AMAZON-AWS-NEURON.PUB | apt-key add -

# RUN apt-get update -y
# RUN apt-get install linux-headers-$(uname -r) -y
# RUN apt-get install git -y

# # Install Neuron Runtime 
# RUN apt-get install aws-neuronx-collectives=2.* -y
# RUN apt-get install aws-neuronx-runtime-lib=2.* -y

# # Install Neuron Tools
# RUN apt-get install aws-neuronx-tools=2.* -y
# ENV PATH="/opt/aws/neuron/bin:$PATH"

# # Install venv
# RUN apt-get install -y python3.8-venv g++

# # Install pip
# RUN apt-get update && apt-get install -y python3-pip


# # Create Python venv
# RUN python3.8 -m venv aws_neuron_venv_pytorch 
# ENV VIRTUAL_ENV /aws_neuron_venv_pytorch
# ENV PATH /aws_neuron_venv_pytorch/bin:$PATH
# RUN pip install --upgrade pip

# # Install Jupyter notebook kernel
# RUN pip install ipykernel 
# RUN python3.8 -m ipykernel install --user --name aws_neuron_venv_pytorch --display-name "Python (torch-neuronx)"
# RUN pip install jupyter notebook
# RUN pip install environment_kernels

# # Set pip repository pointing to the Neuron repository 
# RUN pip config set global.extra-index-url https://pip.repos.neuron.amazonaws.com

# # Install wget, awscli 
# RUN pip install wget 
# RUN pip install awscli 

# # Install Neuron Compiler and Framework
# RUN pip install neuronx-cc==2.* --pre torch-neuronx==2.1.* torchvision


# # transformers_neuronx
# RUN pip install transformers-neuronx --extra-index-url=https://pip.repos.neuron.amazonaws.com

# # install ray
# RUN pip uninstall starlette
# RUN pip install "ray[serve]"
# RUN pip install starlette==0.34.0
# # RUN pip install optimum[neuronx]


# # COPY mistral-7b-ray-hosted.py .
# # COPY Llama-2-13b-chat-hf-neuron-throughput-ray-hosted.py .
# COPY mistral-7b-ray-streaming.py .
# # COPY t.py .
# # COPY infer.py .
# COPY run.sh .

# EXPOSE 8000
# EXPOSE 8265

# # launch ray app
# CMD ["bash", "run.sh"]/
