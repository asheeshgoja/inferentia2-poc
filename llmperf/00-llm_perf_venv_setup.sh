# # Install Python venv 
sudo apt-get install -y python3.8-venv g++ 

# # Create Python venv
python3.8 -m venv llmperf_venv 

# Activate Python venv 
source llmperf_venv/bin/activate 
python -m pip install -U pip 

# Install Jupyter notebook kernel
pip install ipykernel 
python3.10 -m ipykernel install --user --name llmperf_venv --display-name "Python (torch-neuronx)"
pip install jupyter notebook
pip install environment_kernels

# Set pip repository pointing to the Neuron repository 
# python -m pip config set global.extra-index-url https://pip.repos.neuron.amazonaws.com

# Install wget, awscli 
# pip install wget 
# pip install awscli 

# # Install Neuron Compiler and Framework
# pip install neuronx-cc==2.12.54.0 --pre torch-neuronx==2.1.* torchvision


pip uninstall starlette
pip install "ray[serve]"
pip install starlette==0.34.0
# pip install optimum[neuronx]

source llmperf_venv/bin/activate