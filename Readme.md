### Steps to run this demo
- Containerized Mistral-7B-Instruct hosted on Ray and using pytorch torch-neuronx 2.1(beta) 

### Prequisites 
- H/W [Inf2.48xlarge ](https://aws.amazon.com/ec2/instance-types/inf2/)
- OS - ubuntu:jammy 

### Installation Steps
- Download Mistral-7B-Instruct-v0.1 and Mistral Neuron
    ```bash
    mkdir mistralai
    cd mistralai
    git clone https://huggingface.co/aws-neuron/Mistral-neuron
    git clone https://huggingface.co/mistralai/Mistral-7B-Instruct-v0.1
    ```
- Install container runtime on the host os
    ```bash
    ./01-host_os_install.sh
    ```
- Install neuron drivers on the host os
    ```bash
    ./01-host_os_install.sh
    ```

- Build the neuronx container with Mistral-7B hosted on Ray
    ```bash
    ./01-build_container.sh
    ```

- Run the container
    ```bash
    ./03-launch_container.sh
    ```
- You will see the following container logs
    ```bash
    2024-02-09 21:06:39,344 INFO worker.py:1715 -- Started a local Ray instance. View the dashboard at 127.0.0.1:8265 
    (ServeReplica:default:MistralModel pid=19319) Compiler status PASS
    (ServeReplica:default:MistralModel pid=19319) .
    (ServeReplica:default:MistralModel pid=19319) Compiler status PASS
    (ServeReplica:default:MistralModel pid=19319) 
    (ServeReplica:default:MistralModel pid=19319) Compiler status PASS
    2024-02-09 21:12:22,888 SUCC scripts.py:483 -- Deployed Serve app successfully.     
     ```


### Latency and Throughput Tests
- Create the llmperf venv
    ```bash
    cd ~
    ./00-llm_perf_venv_setup.sh
    ```
- Install the lib
    ```bash
    source ~/llmperf_venv/bin/activate
    cd llmperf
    pip install -e .
    ```
- Run the test
    ```bash
    ./run_inf2.sh
    ```
- You will see the following results
    ```bash
    INFO worker.py:1715 -- Started a local Ray instance. View the dashboard at http://127.0.0.1:8266 
    100%|███████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████| 5/5 [00:31<00:00,  6.28s/it]
    \Results for token benchmark for inf2_mistral queried with the inf2_mistral api.

    inter_token_latency_s
        p25 = 0.008820344336105566
        p50 = 0.009707073256400208
        p75 = 0.014229026612909326
        p90 = 0.015130397299720245
        p95 = 0.015430854195323885
        p99 = 0.015671219711806794
        mean = 0.011460580752758433
        min = 0.00881514846744954
        max = 0.015731311090927524
        stddev = 0.0032767124894360045
    ttft_s
        p25 = 0.17304442200020276
        p50 = 0.1949133919997621
        p75 = 0.6874039079993963
        p90 = 1.2646136123996259
        p95 = 1.457016847199702
        p99 = 1.6109394350397632
        mean = 0.5690958523997324
        min = 0.14069745799952216
        max = 1.6494200819997786
        stddev = 0.6444943115726223
    end_to_end_latency_s
        p25 = 1.1357433819994185
        p50 = 5.280329520000123
        p75 = 11.678237965000335
        p90 = 11.934449481999764
        p95 = 12.019853320999573
        p99 = 12.08817639219942
        mean = 6.074523393799791
        min = 0.17304894199969567
        max = 12.105257159999383
        stddev = 5.648474558977279
    request_output_throughput_token_per_s
        p25 = 5.778712013170001
        p50 = 9.658488131626832
        p75 = 9.676117265178263
        p90 = 9.68161878222262
        p95 = 9.683452621237405
        p99 = 9.684919692449235
        mean = 7.12493824721148
        min = 0.8260873658301127
        max = 9.685286460252192
        stddev = 3.9041842896326022
    number_input_tokens
        p25 = 475.0
        p50 = 519.0
        p75 = 683.0
        p90 = 698.0
        p95 = 703.0
        p99 = 707.0
        mean = 570.8
        min = 469
        max = 708
        stddev = 115.79810015712694
    number_output_tokens
        p25 = 93.0
        p50 = 117.0
        p75 = 599.0
        p90 = 1034.0
        p95 = 1178.9999999999998
        p99 = 1295.0
        mean = 428.8
        min = 11
        max = 1324
        stddev = 551.1099708769567
    Number Of Errored Requests: 0
    Overall Output Throughput: 68.24661789697764
    Number Of Completed Requests: 5
    Completed Requests Per Minute: 9.549433474390527
    ```
