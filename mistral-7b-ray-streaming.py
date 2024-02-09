import asyncio
import logging
from queue import Empty
from fastapi import FastAPI
from starlette.responses import StreamingResponse
from transformers import AutoModelForCausalLM, AutoTokenizer, TextIteratorStreamer
from ray import serve
import torch 


logger = logging.getLogger("ray.serve")
fastapi_app = FastAPI()
local_model_path  = "/host_files/mistralai/Mistral-neuron"
hf_model_path = "/host_files/mistralai/Mistral-7B-Instruct-v0.1"


@serve.deployment(
    ray_actor_options={"resources": {"neuron_cores": 24},
                       "runtime_env": {"env_vars": {"NEURON_CC_FLAGS": "--model-type=transformer-inference"}}},
    autoscaling_config={"min_replicas": 1, "max_replicas": 1},
)
@serve.ingress(fastapi_app)
class MistralModel:
    def __init__(self):
        import torch 
        from transformers import AutoTokenizer
        from transformers_neuronx.mistral.model import MistralForSampling , MistralForCausalLM, MistralConfig
        from transformers_neuronx.module import save_pretrained_split 


        print(f"Loading and compiling model {local_model_path} for Neuron")
        self.model = MistralForSampling.from_pretrained(local_model_path, batch_size=1, tp_degree=24, amp='f16')     
        self.model.to_neuron()
        self.tokenizer = AutoTokenizer.from_pretrained(hf_model_path)
        self.loop = asyncio.get_running_loop()

    @fastapi_app.post("/")
    def handle_request(self, prompt: str, temperature: float, max_tokens : int, top_p : float , top_k : int) -> StreamingResponse:
        print(f'prompt: {prompt} , temperature: {temperature} , max_tokens:{max_tokens} top_p:{top_p} top_k:{top_k}')
        streamer = TextIteratorStreamer(
            self.tokenizer, timeout=0, skip_prompt=True, skip_special_tokens=True
        )
        self.loop.run_in_executor(None, self.generate_text, prompt, streamer, temperature, max_tokens, top_p, top_k)
        return StreamingResponse(
            self.consume_streamer(streamer), media_type="text/plain"
        )

    def generate_text(self, prompt: str, streamer: TextIteratorStreamer, temperature: float, max_tokens : int, top_p : float , top_k : int):
        input_ids = self.tokenizer([prompt], return_tensors="pt").input_ids
        with torch.inference_mode():
            self.model.sample(input_ids, sequence_length=max_tokens, top_k=top_k, top_p=top_p, temperature=temperature, streamer=streamer)


    async def consume_streamer(self, streamer: TextIteratorStreamer):
        while True:
            try:
                for token in streamer:
                    print(f'Yielding token: "{token}"')
                    yield token
                break
            except Empty:
                await asyncio.sleep(0.001)


entrypoint = MistralModel.bind()
